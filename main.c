#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

/*      lua       */
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

static int running = 1;

/* this is a C function being made available in lua
 * it uses a very specific protocol for lua.
 */
static int 
foo (lua_State *L) {
	int n = lua_gettop(L);    /* number of arguments */
	lua_Number sum = 0.0;
	int i;
	for (i = 1; i <= n; i++) {
		if (!lua_isnumber(L, i)) {
			lua_pushliteral(L, "incorrect argument");
			lua_error(L);
		}
		sum += lua_tonumber(L, i);
	}
	lua_pushnumber(L, sum/n);        /* first result */
	lua_pushnumber(L, sum);         /* second result */
	return 2;                   /* number of results */
}

static int
stopGame(lua_State *L) {
	running = 0;
	return 0;
}

void
setCFunctions(lua_State *luaCtx) {
	lua_pushcfunction(luaCtx, &stopGame);
	lua_setglobal(luaCtx, "stopGame");

	lua_pushcfunction(luaCtx, &foo);
	lua_setglobal(luaCtx, "foo");
}

int main() {
	lua_State *luaCtx = NULL;
	luaCtx = luaL_newstate();

	if (!luaCtx) {
		printf("Error allocating lua state\n");
		return 1;
	}

	luaL_openlibs(luaCtx);

	setCFunctions(luaCtx);

	if (luaL_dofile(luaCtx, "main.lua") != 0) {
		const char *msg = lua_tostring(luaCtx, -1);
		printf("Error in the script file main.lua -> %s\n", msg);
	}

	lua_getglobal(luaCtx, "Init");
	lua_pcall(luaCtx, 0, 0, 0);

	while (running) {
		/* the goal is to call Poll 30 times per second */
		lua_getglobal(luaCtx, "Poll");
		if (lua_pcall(luaCtx, 0, 0, 0) != 0) {
			const char *msg = lua_tostring(luaCtx, -1);
			/* we don't care about the error, 
			 * usually it's just that the function doesn't exist
			 */
		}

		usleep(3000);
	}

	lua_close(luaCtx);

	return 0;
}

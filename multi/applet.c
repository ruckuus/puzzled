#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "applet.h"

int main(int argc, char **argv)
{
	struct applet *foo;
	char *res;
	char *app_name = "applet";
	int rv;
	if ((argc < 0) || (argv[0] == NULL)) {
		print_usage(argv[0]);
		return -1;
	}

	fprintf(stdout, "calling: %s\n", argv[0]);
	foo = applet_alloc();

	if (!foo)
		return -1;

	app_name = parse_argv(argv[0]);
	foo->id = 1;
	foo->name = app_name;

	rv = get_applet(foo);
	if (rv >= 0) {
		printf("get %s at %d\n", foo->name, rv);
		do_exec(foo);
	} else {
		printf("Applet %s not available!\n", foo->name);
		print_usage(argv[0]);
	}

	free(foo);
	foo = NULL;
	return 0;
}

int get_applet(struct applet *foo)
{
	int cnt;
	int asize;
	int i, appid;

	asize = sizeof(applets) / sizeof(applets[0]);
	while (asize--) {
		if (strcmp(applets[asize], foo->name) == 0) {
			appid = asize;
			foo->app = applet_callback[asize];
			return appid;
		}

	}
	return -1;
}

void print_usage(char *arg)
{
	int i;
	int a;
	a = sizeof(applets)/sizeof(applets[0]);
	printf("Use it wisely! %s args\n", arg);
	printf("Available applets:\n");
	for (i = 0; i < a; i++) {
		printf("\t %s\n", applets[i]);
	}

}

void do_exec(struct applet *foo)
{
	foo->app();
}

struct applet *applet_alloc(void)
{
	struct applet *applet;
	applet = malloc(sizeof(struct applet));

	if (!applet)
		return NULL;
	return applet;
}

char *parse_argv(const char *arg)
{
	int args;
	int c = 0;
	int x = 0;
	int pos = 0;
	args = strlen(arg);
	char *to = (char *)calloc(sizeof(char), args);

	/* Condition:
	 * 1. call by name: applet
	 * 2. call by full path: /path/to/applet
	 * 3. call in the same dir: ./applet
	 */
	if (arg[0] == '.' && arg[1] == '/') {
		strncpy(to, arg + 2, args - 2);
	} else if (arg[0] == '/') {
		while(arg[c] != '\0') {
			c++;
			x++;
			if (arg[c] == '/')
				x = 0;
		}
		pos = args - x;
		strncpy(to, arg + pos + 1, args - pos);
	} else {
		to = strncpy(to, arg, args);
	}

	return to;
}

void applet0(void)
{
	printf("Applet0 is running!\n");
}

void applet1(void)
{
	printf("Applet1 is running!\n");
}

void applet2(void)
{
	printf("Applet2 is running!\n");
}

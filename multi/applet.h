#ifndef __APPLET_H__
#define __APPLET_H__
#endif

#define APPLET_MAX_NAME	10
struct applet {
	int id;
	char *name;
	void (*app) (void);
};

int get_applet(struct applet *foo);
char *parse_argv(const char *arg);
void print_usage(char *arg);
void do_exec(struct applet *foo);
void func_foo(void);
void applet0(void);
void applet1(void);
void applet2(void);
struct applet *applet_alloc(void);

/* Array of pointer to function */
static void (*applet_callback[]) (void) = {
	applet0, applet1, applet2};

/* Array of applet name */
const char *applets[] = { "applet0", "applet1", "applet2" };


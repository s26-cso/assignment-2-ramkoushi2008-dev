#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main()
{
    while (1)
    {
        char operation[12];
        char lib_name[32] = "lib";
        int x, y;

        if (scanf("%s %d %d", operation, &x, &y) != 3)
            break;

        strcat(lib_name, operation);
        strcat(lib_name, ".so");

        void *handle = dlopen(lib_name, RTLD_LAZY);
        if (!handle)
            continue;

        int (*func_ptr)(int, int);
        *(void **)(&func_ptr) = dlsym(handle, operation);

        if (func_ptr)
            printf("%d\n", func_ptr(x, y));

        dlclose(handle);
    }

    return 0;
}
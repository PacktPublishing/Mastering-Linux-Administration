#include <unistd.h>
#include <stdio.h>

FILE *f;
char LOG_FILE[] = "/var/log/messages";

int main(void)
{
    while (1) {
        f = fopen(LOG_FILE, "w");
        sleep(10);
        fclose(f);
    }
}

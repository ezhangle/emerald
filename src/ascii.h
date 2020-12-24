#ifndef ASCII_H
#define ASCII_H
#include <devices/RTC/rtc.h>
#include <libstr/string.h>
#include <debug-utilities/logger.h>
char ascii_art[] = "\e[0;32m  _____                         _     _ \n"
                  " |  ___|                       | |   | |\n"
                  " | |__ _ __ ___   ___ _ __ __ _| | __| |\n"
                  " |  __| '_ ` _ \\ / _ \\ '__/ _` | |/ _` |\n"
                  " | |__| | | | | |  __/ | | (_| | | (_| |\n"
                  " \\____/_| |_| |_|\\___|_|  \\__,_|_|\\__,_|\n\e[0m"
                  " ─────────────────────────────────────────────────\n"
                  "Copyright (c) 2020 EmeraldOS contributors\n"
  "                                               \n";

void set_ascii()
{
  
if (hour<12)
  {
    strcpy(&ascii_art[448],"Good Morning!\n");
  }
if (hour>=12 && hour<18)
  {
    strcpy(&ascii_art[448],"Good Afternoon!\n");
  }
if (hour>=18)
  {
    strcpy(&ascii_art[448],"Good Evening!\n");
  }
 puts(ascii_art);
}
#endif
#include <stdio.h>
#include <WString.h>

char* convertStringToCharArray (String string) {
    char *charString = new char[string.length() + 1];
    strcpy(charString, string.c_str());
    return charString;
}


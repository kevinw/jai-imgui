

struct My_Struct {

    void *member_func(float s);
    virtual void *virtual_member_func(float s);
};

// void *My_Struct::member_func(float s) {

// }


int test(float a);
char test(double b);

extern "C" {
    short my_func(char *str);
}

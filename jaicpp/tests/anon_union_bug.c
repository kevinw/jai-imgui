


struct My_Struct {
    int test;

    union {
        int a1;
    };

    struct {
        float whoah;
    };

    union {
        float whatever;
    } test_union;

    union T {
        char *h;
    } t1;

    union T t2;

    // @FixMe this case doesnt work yet because we need to be able to identify declarations that refer to the same unnamed union
    // and then print them together as a comma-separated group, otherwise, they may be declared the same, but since they will both
    // use anonymous types, the two declarations will be considered binarily imcompatible;
    union {
        float bb;
    } z1, z2;

    int test2;
};

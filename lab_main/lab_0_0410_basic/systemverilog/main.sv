// Nhóm 6 - 20251


// 1. Enum
module tb;
    typedef enum {TRUE, FALSE} e_true_false;
    initial begin
        e_true_false answer;
        answer = TRUE;
        $display("answer = %s", answer.name);
    end
endmodule


// 2. Enum range
module enum_ranges;
    typedef enum {GREEN, YELLOW, RED, BLUE} color_set_1;
    typedef enum {MAGENTA=2, VIOLET=7, PURPLE, PINK} color_set_2;
    typedef enum {BLACK[4]} color_set_3;
    typedef enum {RED[3] = 5}color_set_4;
    typedef enum {YELLOW[3:5]} color_set_5;
    typedef enum {WHITE[3:5] = 4}color_set_6;
    initial begin
        color_set_1 color1;
        color_set_2 color2;
        color_set_3 color3;
        color_set_4 color4;
        color_set_5 color5;
        color_set_6 color6;
        color1 = YELLOW; $display ("color1=%0d, name=%s", color1,color1.name());
        color2 = PURPLE; $display ("color2=%0d, name=%s", color2,color2.name());
        color3 = BLACK3; $display ("color3=%0d, name=%s", color3,color3.name());
        color4 = RED1; $display ("color4=%0d, name=%s", color4,color4.name());
        color5 = YELLOW3;$display ("color5=%0d, name=%s", color5,color5.name());
        color6 = WHITE4; $display ("color6=%0d, name=%s", color6,color6.name());
    end
endmodule

// 3. Enum methods
typedef enum {GREEN, YELLOW, RED, BLUE} colors;
module enum_methods;
    initial begin
        colors color;
        color = YELLOW;
        $display("color.first() = %0d", color.first()); 
        $display("color.last() = %0d", color.last()); 
        $display("color.prev() = %0d", color.prev()); 
        $display("color.num() = %0d", color.num()); 
        $display("color.name() = %s", color.name()); 
    end
endmodule

// 4. Static array
module tb;
    bit [7:0] m_data; 
    initial begin
        m_data = 8'hA2;
        for (int i = 0; i < $size(m_data); i++) begin
        $display ("m_data[%0d] = %b", i, m_data[i]);
        end
    end
endmodule

// 5. Packed array
module tb;
    bit [3:0][7:0] m_data; 
    initial begin
        m_data = 32'hface_cafe;
        $display ("m_data = 0x%0h", m_data);
        for (int i = 0; i < $size(m_data); i++) begin
            $display ("m_data[%0d] = %b (0x%0h)", i, m_data[i], m_data[i]);
        end
    end
endmodule

// 6. Unpacked array
module tb;
    byte stack [2][4]; 
    initial begin
        foreach (stack[i]) begin
            foreach (stack[i][j]) begin
                stack[i][j] = $random;
                $display ("stack[%0d][%0d] = 0x%0h", i, j, stack[i][j]);
            end
        end
        $display ("stack = %p", stack);
    end
endmodule

// 7. Dynamic array
module tb;
    int array [];
    initial begin
        array = new [5];
        array = '{31, 67, 10, 4, 99};
        foreach (array[i])
            $display ("array[%0d] = %0d", i, array[i]);
    end
endmodule

// 8. Dynamic Array Method
module tb;
    string fruits [];
    initial begin
        fruits = new [3];
        fruits = '{"apple", "orange", "mango"};
        $display ("fruits.size() = %0d", fruits.size());
        fruits.delete();
        $display ("fruits.size() = %0d", fruits.size());
    end
endmodule

// 9. Add items to dynamic array
module tb;
    int array [];
    int id [];
    initial begin
        array = new [5];
        array = '{1, 2, 3, 4, 5};
        id = array;
        $display ("id = %p", id);
        id = new [id.size() + 1] (id);
        id[id.size() - 1] = 6;
        $display ("New id = %p", id);
        $display ("array.size() = %0d, id.size() = %0d", array.size(),id.size());
    end
endmodule

// 10. Associative array
module tb;
    int array1 [int]; 
    int array2 [string]; 
    string array3 [string]; 
    initial begin
        array1 = '{ 1 : 22,
        6 : 34 };
        array2 = '{ "Ross" : 100,
        "Joey" : 60 };
        array3 = '{ "Apples" : "Oranges",
        "Pears" : "44" };
        $display ("array1 = %p", array1); $display ("array2 = %p", array2);
        $display ("array3 = %p", array3);
    end
endmodule

// 10. Associate Array with method
module tb;
    int fruits_l0 [string];

    initial begin
        fruits_l0 = '{
        "apple" : 4,
        "orange" : 10,
        "plum" : 9,
        "guava" : 1
        };

        $display("fruits_l0.size() = %0d", fruits_l0.size());

        $display("fruits_l0.num() = %0d", fruits_l0.num());

        if (fruits_l0.exists("orange"))
        $display("Found %0d orange !", fruits_l0["orange"]);

        if (!fruits_l0.exists("apricots"))
        $display("Sorry, season for apricots is over ...");

        begin
        string f;
        if (fruits_l0.first(f))
            $display("fruits_l0.first [%s] = %0d", f, fruits_l0[f]);
        end

        begin
        string f;
        if (fruits_l0.last(f))
            $display("fruits_l0.last [%s] = %0d", f, fruits_l0[f]);
        end

        begin
        string f = "orange";
        if (fruits_l0.prev(f))
            $display("fruits_l0.prev [%s] = %0d", f, fruits_l0[f]);
        end

        begin
        string f = "orange";
        if (fruits_l0.next(f))
            $display("fruits_l0.next [%s] = %0d", f, fruits_l0[f]);
        end
    end
endmodule

// 11. Dynamic array of Associative arrays
module tb;

    int fruits [] [string];

    initial begin
    fruits = new [2];

    fruits[0] = '{ "apple" : 1, "grape" : 2 };
    fruits[1] = '{ "melon" : 3, "cherry" : 4 };

    foreach (fruits[i])
        foreach (fruits[i][fruit])
        $display("fruits[%0d][%s] = %0d", i, fruit, fruits[i][fruit]);
    end
endmodule

// 12. Array Manipulation Methods
module tb;
  int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};
  int res[$];

  initial begin
    res = array.find(x) with (x > 3);
    $display("find(x)              : %p", res);

    res = array.find_index with (item == 4);
    $display("find_index           : res[%0d] = 4", res[0]);

    res = array.find_first with (item < 5 & item >= 3);
    $display("find_first           : %p", res);

    res = array.find_first_index(x) with (x > 5);
    $display("find_first_index     : %p", res);

    res = array.find_last with (item <= 7 & item > 3);
    $display("find_last            : %p", res);

    res = array.find_last_index(x) with (x < 3);
    $display("find_last_index      : %p", res);
  end
endmodule

// 13. Array Manipulation Methods 'with'
module tb;
    int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};
    int res[$];

    initial begin
        res = array.min();
        $display("min           : %p", res);

        res = array.max();
        $display("max           : %p", res);

        res = array.unique();
        $display("unique        : %p", res);

        res = array.unique(x) with (x < 3);
        $display("unique (x<3)  : %p", res);

        res = array.unique_index;
        $display("unique_index  : %p", res);
    end
endmodule

// 14. Array Ordering Methods
module tb;
    int array[9] = '{4, 7, 2, 5, 7, 1, 6, 3, 1};

    initial begin
        array.reverse();
        $display("reverse : %p", array);

        array.sort();
        $display("sort    : %p", array);

        array.rsort();
        $display("rsort   : %p", array);

        for (int i = 0; i < 5; i++) begin
            array.shuffle();
            $display("shuffle Iter:%0d = %p", i, array);
        end
    end
endmodule

// 15. Array Reduction Methods
module tb;
    int array[4] = '{1, 2, 3, 4};
    int res[$];

    initial begin
        $display("sum      = %0d", array.sum());
        $display("product  = %0d", array.product());
        $display("and      = 0x%0h", array.and());
        $display("or       = 0x%0h", array.or());
        $display("xor      = 0x%0h", array.xor());
    end
endmodule

// 16. Queue
module queue_methods;
    string fruits[$] = {"apple", "pear", "mango", "banana"};

    initial begin
        $display ("Number of fruits=%0d fruits=%p", fruits.size(), fruits);

        fruits.insert(1, "peach");
        $display ("Insert peach, size=%0d fruits=%p", fruits.size(), fruits);

        fruits.delete(3);
        $display ("Delete mango, size=%0d fruits=%p", fruits.size(), fruits);

        $display ("Pop %s,    size=%0d fruits=%p", fruits.pop_front(), fruits.size(), fruits);

        fruits.push_front("apricot");
        $display ("Push apricot, size=%0d fruits=%p", fruits.size(), fruits);

        $display ("Pop %s,    size=%0d fruits=%p", fruits.pop_back(), fruits.size(), fruits);

        fruits.push_back("plum");
        $display ("Push plum,    size=%0d fruits=%p", fruits.size(), fruits);
    end
endmodule

// 17. Typedef struct
module typedef_struct;

typedef struct {
    string fruit;
    int    count;
    byte   expiry;
} st_fruit;

    initial begin
        st_fruit fruit1 = '{"apple", 4, 15};
        st_fruit fruit2;

        $display("fruit1 = %p fruit2 = %p", fruit1, fruit2);

        fruit2 = fruit1;
        $display("fruit1 = %p fruit2 = %p", fruit1, fruit2);

        fruit1.fruit = "orange";
        $display("fruit1 = %p fruit2 = %p", fruit1, fruit2);
    end
endmodule

// 18. Packed-struct
typedef struct packed {
    bit [3:0] mode;
    bit [2:0] cfg;
    bit       en;
} st_ctrl;

module packed_structures;
    st_ctrl ctrl_reg;

    initial begin
        ctrl_reg = '{4'ha, 3'h5, 1};
        $display("ctrl_reg = %p", ctrl_reg);

        ctrl_reg.mode = 4'h3;
        $display("ctrl_reg = %p", ctrl_reg);

        ctrl_reg = 8'hfa;
        $display("ctrl_reg = %p", ctrl_reg);
    end
endmodule

// 19. User-defined data type
module user_defined;
    shortint unsigned         my_data;
    enum {RED, YELLOW, GREEN} e_light;
    bit [7:0]                 my_byte;

    typedef shortint unsigned u_shorti;
    typedef enum {RED, YELLOW, GREEN} e_light;
    typedef bit [7:0] ubyte;

    u_shorti my_data;
    e_light  light1;
    ubyte    my_byte;

    initial begin
        _u_shorti data = 32'hface_cafe;
        _e_light  light = GREEN;
        _ubyte    cnt = 8'hFF;
        $display("light=%s data=0x%0h cnt=%0d", light.name(), data, cnt);
    end
endmodule

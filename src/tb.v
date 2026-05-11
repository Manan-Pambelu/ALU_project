`timescale 1ns/1ps

module alu_testbench;

    reg [7:0] OPA, OPB;
    reg CLK, RST, CE, MODE, CIN;
    reg [3:0] CMD;
    reg [1:0] INP_VALID;

    wire [15:0] RES_dut;
    wire COUT_dut, OFLOW_dut, G_dut, E_dut, L_dut, ERR_dut;

    wire [15:0] RES_ref;        
    wire COUT_ref, OFLOW_ref, G_ref, E_ref, L_ref, ERR_ref;

    integer pass_count = 0;
    integer fail_count = 0;
    integer test_count = 0;

    reg cmp;

    alu
         dut(
        .OPA(OPA),
        .OPB(OPB),
        .CIN(CIN),
        .CLK(CLK),
        .RST(RST),
        .CMD(CMD),
        .CE(CE),
        .MODE(MODE),
        .INP_VALID(INP_VALID),
        .COUT(COUT_dut),
        .OFLOW(OFLOW_dut),
        .RES(RES_dut),
        .G(G_dut),
        .E(E_dut),
        .L(L_dut),
        .ERR(ERR_dut)
    );

    alu_reference_model ref (
        .CE(CE),
        .OPA(OPA),
        .OPB(OPB),
        .CIN(CIN),
        .MODE(MODE),
        .CMD(CMD),
        .INP_VALID(INP_VALID),
        .RES(RES_ref),
        .COUT(COUT_ref),
        .OFLOW(OFLOW_ref),
        .G(G_ref),
        .E(E_ref),
        .L(L_ref),
        .ERR(ERR_ref)
    );

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin
       
        RST       = 0;
        CE        = 0;
        CIN       = 0;
        OPA       = 0;
        OPB       = 0;
        MODE      = 0;
        CMD       = 0;
        INP_VALID = 2'b00;

        @(posedge CLK);
        RST       = 1;
        CE        = 0;
        CIN       = 0;
        OPA       = 0;
        OPB       = 0;
        MODE      = 0;
        CMD       = 0;
        INP_VALID = 2'b00;

        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        CIN       = 0;
        OPA       = 0;
        OPB       = 0;
        MODE      = 0;
        CMD       = 0;
        INP_VALID = 2'b11;

        @(posedge CLK);
        RST       = 0;
        CE        = 0;
        CIN       = 0;
        OPA       = 0;
        OPB       = 0;
        MODE      = 0;
        CMD       = 0;
        INP_VALID = 2'b11;

        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        CIN       = 0;
        OPA       = 1;
        OPB       = 1;
        MODE      = 1;
        CMD       = 0;
        INP_VALID = 2'b11;

        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        CIN       = 0;
        OPA       = 1;
        OPB       = 1;
        MODE      = 0;
        CMD       = 0;
        INP_VALID = 2'b11;

        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        CIN       = 0;
        OPA       = 1;
        OPB       = 1;
        MODE      = 1;
        CMD       = 4'b1111;
        INP_VALID = 2'b11;

        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        CIN       = 0;
        OPA       = 1;
        OPB       = 1;
        MODE      = 0;
        CMD       = 4'b1111;
        INP_VALID = 2'b11;

        
        @(posedge CLK);
        RST       = 0;
        CE        = 1;
        INP_VALID = 2'b11;

        @(posedge CLK);

        $display("\n=== Testing Arithmetic Operations (MODE=1) ===");
        MODE = 1;
        INP_VALID = 2'b11;
        test_arithmetic();

        $display("\n=== Testing Arithmetic Operations (INVALID=b01) ===");
        INP_VALID = 2'b01;
        test_arithmetic();

        $display("\n=== Testing Arithmetic Operations (INVALID=b10) ===");
        INP_VALID = 2'b10;
        test_arithmetic();

        $display("\n=== Testing Arithmetic Operations (INVALID=b00) ===");
        INP_VALID = 2'b00;
        test_arithmetic();

        $display("\n=== Testing Logical Operations (MODE=0) ===");
        MODE = 0;
        INP_VALID = 2'b11;
        test_logical();

        $display("\n=== Testing Logical Operations (INVALID=b01) ===");
        INP_VALID = 2'b01;
        test_logical();

        $display("\n=== Testing Logical Operations (INVALID=b10) ===");
        INP_VALID = 2'b10;
        test_logical();

        $display("\n=== Testing Logical Operations (INVALID=b00) ===");
        INP_VALID = 2'b00;
        test_logical();

        $display("\n=== TEST SUMMARY ===");
        $display("Total Tests: %0d", test_count);
        $display("PASS: %0d", pass_count);
        $display("FAIL: %0d", fail_count);

        if (fail_count == 0)
            $display("\n*** ALL TESTS PASSED ***\n");
        else
            $display("\n*** SOME TESTS FAILED ***\n");

        #200;
        $finish;
    end

    task test_arithmetic();
        begin
            apply_test(8'h01, 8'h01, 4'b0000, "ADD");
            apply_test(8'hFF, 8'h01, 4'b0000, "ADD");
            apply_test(8'h00, 8'h00, 4'b0000, "ADD");

            apply_test(8'h01, 8'h01, 4'b0001, "SUB");
            apply_test(8'h00, 8'h01, 4'b0001, "SUB");
            apply_test(8'h50, 8'h50, 4'b0001, "SUB");

            CIN = 1;
            apply_test(8'hFF, 8'h00, 4'b0010, "ADD_CIN");
            CIN = 0;
            apply_test(8'hFF, 8'h00, 4'b0010, "ADD_CIN");
            CIN = 1;
            apply_test(8'h01, 8'h01, 4'b0010, "ADD_CIN");
            CIN = 0;

            CIN = 1;
            apply_test(8'h0A, 8'h03, 4'b0011, "SUB_CIN");
            apply_test(8'h00, 8'h00, 4'b0011, "SUB_CIN");
            CIN = 0;
            apply_test(8'h01, 8'h01, 4'b0011, "SUB_CIN");
            CIN = 1;
            apply_test(8'h01, 8'h01, 4'b0011, "SUB_CIN");
            CIN = 0;

            apply_test(8'h50, 8'h00, 4'b0100, "INC_A");
            apply_test(8'hFF, 8'h00, 4'b0100, "INC_A");
            apply_test(8'h0A, 8'h00, 4'b0100, "INC_A");

            apply_test(8'h49, 8'h00, 4'b0101, "DEC_A");
            apply_test(8'h00, 8'h00, 4'b0101, "DEC_A");
            apply_test(8'h0A, 8'h00, 4'b0101, "DEC_A");

            apply_test(8'h00, 8'h50, 4'b0110, "INC_B");
            apply_test(8'h00, 8'hFF, 4'b0110, "INC_B");

            apply_test(8'h00, 8'h49, 4'b0111, "DEC_B");
            apply_test(8'h00, 8'h00, 4'b0111, "DEC_B");

            apply_test(8'd200, 8'd100, 4'b1000, "CMP");
            apply_test(8'd50,  8'd200, 4'b1000, "CMP");
            apply_test(8'd128, 8'd128, 4'b1000, "CMP");

            apply_test(8'h00, 8'h00, 4'b1001, "MUL_AB");
            apply_test(8'h01, 8'h01, 4'b1001, "MUL_AB");
            apply_test(8'hFF, 8'h01, 4'b1001, "MUL_AB");
            apply_test(8'h01, 8'hFF, 4'b1001, "MUL_AB");
            apply_test(8'h0F, 8'h0F, 4'b1001, "MUL_AB");
            apply_test(8'hF0, 8'h0F, 4'b1001, "MUL_AB");
            apply_test(8'hAA, 8'h55, 4'b1001, "MUL_AB");
            apply_test(8'h55, 8'hAA, 4'b1001, "MUL_AB");
            apply_test(8'h7F, 8'h7F, 4'b1001, "MUL_AB");
            apply_test(8'h80, 8'h80, 4'b1001, "MUL_AB");
            apply_test(8'hFF, 8'hFF, 4'b1001, "MUL_AB");

            apply_test(8'h01, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h03, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h0F, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h1F, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h3F, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h7F, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'hFF, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'h00, 8'h01, 4'b1010, "SHIFT_MUL");
            apply_test(8'hFF, 8'hFE, 4'b1010, "SHIFT_MUL");
            apply_test(8'h5F, 8'h55, 4'b1010, "SHIFT_MUL");
            apply_test(8'hAA, 8'h01, 4'b1010, "SHIFT_MUL");

            apply_test(8'h10, 8'h20, 4'b1011, "S_ADD");
            apply_test(8'h20, 8'h10, 4'b1011, "S_ADD");
            apply_test(8'h20, 8'h20, 4'b1011, "S_ADD");
            apply_test(8'h70, 8'h70, 4'b1011, "S_ADD");
            apply_test(8'hA0, 8'hA0, 4'b1011, "S_ADD");
            apply_test(8'h10, 8'h10, 4'b1011, "S_ADD");
            apply_test(8'h70, 8'h90, 4'b1011, "S_ADD");
            apply_test(8'h90, 8'h20, 4'b1011, "S_ADD");

            apply_test(8'h50, 8'h30, 4'b1100, "S_SUB");
            apply_test(8'h30, 8'h50, 4'b1100, "S_SUB");
            apply_test(8'h40, 8'h40, 4'b1100, "S_SUB");
            apply_test(8'h70, 8'h90, 4'b1100, "S_SUB");
            apply_test(8'hA0, 8'h70, 4'b1100, "S_SUB");
            apply_test(8'h90, 8'h70, 4'b1100, "S_SUB");
            apply_test(8'h50, 8'h10, 4'b1100, "S_SUB");
            apply_test(8'h02, 8'hFF, 4'b1100, "S_SUB");
            apply_test(8'h10, 8'hF0, 4'b1100, "S_SUB");
        end
    endtask

    task test_logical();
        begin
            apply_test(8'hAA, 8'h55, 4'b0000, "AND");
            apply_test(8'hAA, 8'h55, 4'b0001, "NAND");
            apply_test(8'hAA, 8'h55, 4'b0010, "OR");
            apply_test(8'hAA, 8'h55, 4'b0011, "NOR");
            apply_test(8'hFF, 8'hFF, 4'b0100, "XOR");
            apply_test(8'hFF, 8'hFF, 4'b0101, "XNOR");
            apply_test(8'hAA, 8'hAA, 4'b0110, "NOT_A");
            apply_test(8'hAA, 8'hAA, 4'b0111, "NOT_B");

            apply_test(8'b10101010, 8'd0,        4'b1000, "SHR1_A");
            apply_test(8'b01010101, 8'h00,       4'b1001, "SHL1_A");
            apply_test(8'h00,       8'b10101010, 4'b1010, "SHR1_B");
            apply_test(8'h00,       8'b01010101, 4'b1011, "SHL1_B");

            apply_test(8'hCC, 8'h00, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h01, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h02, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h03, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h04, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h05, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h06, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h07, 4'b1100, "ROL_A_B");
            apply_test(8'hCC, 8'h37, 4'b1100, "ROL_A_B");

            apply_test(8'hCC, 8'h00, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h01, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h02, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h03, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h04, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h05, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h06, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h07, 4'b1101, "ROR_A_B");
            apply_test(8'hCC, 8'h37, 4'b1101, "ROR_A_B");
        end
    endtask

    task apply_test(
        input [7:0] a, b,
        input [3:0] cmd,
        input [80*8:1] test_name
    );
    begin
        
        @(posedge CLK); #1;
        OPA = a;
        OPB = b;
        CMD = cmd;

       
        if (MODE == 1 && (cmd == 4'd9 || cmd == 4'd10 || cmd == 4'd11 || cmd == 4'd12)) begin
            @(posedge CLK); #1;
            @(posedge CLK); #1;
            @(posedge CLK); #1;
        end

        
        @(posedge CLK); #1;

        test_count = test_count + 1;
        compare_outputs(cmp);

        if (cmp) begin
            $display("[PASS] %s", test_name);
            pass_count = pass_count + 1;
        end else begin
            $display("[FAIL] %s", test_name);
            display_mismatch();
            fail_count = fail_count + 1;
        end
    end
    endtask

    task compare_outputs;
        output reg compare__outputs;
        begin
            compare__outputs = 1;
            
            if (RES_dut !== RES_ref[15:0]) compare__outputs = 0;
            if (COUT_dut  !== COUT_ref)    compare__outputs = 0;
            if (OFLOW_dut !== OFLOW_ref)   compare__outputs = 0;
            if (G_dut     !== G_ref)       compare__outputs = 0;
            if (E_dut     !== E_ref)       compare__outputs = 0;
            if (L_dut     !== L_ref)       compare__outputs = 0;
            if (ERR_dut   !== ERR_ref)     compare__outputs = 0;
        end
    endtask

    function compare_bit;
        input dut, ref;
        begin
            if (dut === ref)
                compare_bit = 1;
            else
                compare_bit = 0;
        end
    endfunction

    task display_mismatch();
        begin
            $display("  DUT: RES=0x%h COUT=%b OFLOW=%b G=%b E=%b L=%b ERR=%b",
                     RES_dut, COUT_dut, OFLOW_dut, G_dut, E_dut, L_dut, ERR_dut);
            $display("  REF: RES=0x%h COUT=%b OFLOW=%b G=%b E=%b L=%b ERR=%b",
                     RES_ref[15:0], COUT_ref, OFLOW_ref, G_ref, E_ref, L_ref, ERR_ref);
        end
    endtask

    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, alu_testbench);
    end

endmodule

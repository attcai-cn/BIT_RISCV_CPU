//opcode
`define OPCODE_R    7'b0110011
`define OPCODE_I    7'b0010011
`define OPCODE_L    7'b0000011
`define OPCODE_S    7'b0100011
`define OPCODE_B    7'b1100011
`define OPCODE_JAL  7'b1101111
`define OPCODE_LUI  7'b0110111

//funct3
`define FUNCT3_ADD  3'b000
`define FUNCT3_ADDI 3'b000
`define FUNCT3_SUB  3'b000
`define FUNCT3_XOR  3'b100
`define FUNCT3_XORI 3'b100
`define FUNCT3_OR   3'b110
`define FUNCT3_ORI  3'b110
`define FUNCT3_AND  3'b111
`define FUNCT3_ANDI 3'b111
`define FUNCT3_SLL  3'b001
`define FUNCT3_SRL  3'b101
`define FUNCT3_LW   3'b010
`define FUNCT3_SW   3'b010
`define FUNCT3_BEQ  3'b000
`define FUNCT3_BGE  3'b101
`define FUNCT3_BLT  3'b100
`define FUNCT3_BNE  3'b001

//funct7
`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000
`define FUNCT7_SLL  7'b0000000
`define FUNCT7_SRL  7'b0000000
`define FUNCT7_XOR  7'b0000000
`define FUNCT7_OR   7'b0000000
`define FUNCT7_AND  7'b0000000


//instr_id
`define ID_NULL     0
`define ID_ADD      1
`define ID_ADDI     2
`define ID_SUB      3
`define ID_XOR      4
`define ID_XORI     5
`define ID_OR       6
`define ID_ORI      7
`define ID_AND      8
`define ID_ANDI     9
`define ID_SLL      10
`define ID_SRL      11
`define ID_LW       12
`define ID_SW       13
`define ID_BEQ      14
`define ID_JAL      15
`define ID_LUI      16
`define ID_BGE      17
`define ID_BLT      18
`define ID_BNE      19

//alu_op
`define ALU_NULL    4'b1111
`define ALU_ADD     4'b0000
`define ALU_SUB     4'b0001
`define ALU_AND     4'b0010
`define ALU_OR      4'b0011
`define ALU_XOR     4'b0100
`define ALU_NOT     4'b0101
`define ALU_SLL     4'b0110
`define ALU_SRL     4'b0111

// rounding_mode
`define ROUND_RTZ   2'b00
`define ROUND_RNE   2'b01

//branch
`define BR_NULL     3'b111
`define BR_BEQ      3'b000
`define BR_BNE      3'b001
`define BR_BLT      3'b011
`define BR_BGE      3'b010
`define BR_JAL      3'b110
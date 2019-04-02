.text
.global _start



_start:
	b _reset
	ldr pc, _und_exception

.align 4
_und_exception:
	.word _und_exception_fun
_und_exception_fun:
	ldr sp,=0x34000000
	stmdb sp!,{r0-r12,lr}
	ldr r0,=_und_string
	bl puts
	mrs r0,cpsr
	bl print
	ldr r0,=_enter_string
	bl puts
	ldmia sp!,{r0-r12,pc}^
_und_string:
	.string "undefine exception\n"
_enter_string:
	.string "\n"

.align 4
_reset:
	ldr r0,=0x53000000
	mov r1,#0
	str r1,[r0]

	ldr r0,=0x4C000000
	ldr r1,=0xffffffff
	str r1,[r0]
	ldr r0,=0x4C000014
	ldr r1,=0x5
	str r1,[r0]
	mrc p15,0,r0,c1,c0,0
	orr r0,r0,#0xc0000000  //#R1_nF:OR:R1_iA
	mcr p15,0,r0,c1,c0,0
	ldr r0,=0x4C000004
	ldr r1,=(92<<12)|(1<<4)|(1<<0)
	str r1,[r0]

	mov r1,#0
	ldr r0,[r1]
	str r1,[r1]		/*����0��ַ�����ݱ���*/
	ldr r2,[r0]		/*��0��ַ��д��2*/
	cmp r1,r2		/*�Ƚ�0��ַ�������Ƿ��޸�*/
	ldr sp,=0x40000000+4096		/*����ȣ���Ϊnor����������ջָ��λ�ڲ�SRAM�Ķ�����ַ*/
	moveq sp,#4096		/*��ȣ���Ϊnand����������ջָ��λ�ڲ�SRAM�Ķ�����ַ*/
	streq r0,[r1]		/*�ָ�����*/


	bl sdram_init
	ldr r1,=0
	ldr r2,=_start
	ldr r3,=__bss_start
_relocate:
	ldr r4,[r1]
	str r4,[r2]
	add r1,r1,#4
	add r2,r2,#4
	cmp r2,r3
	ble _relocate

	mov r3,#0
	ldr r1,=__bss_start
	ldr r2,=_end
_bss_relocate:
	str r3,[r1]
	add r1,r1,#4
	cmp r1,r2
	ble _bss_relocate

	bl uart0_init
	ldr r0,=_test_string
	bl puts
	mrs r0,cpsr
	bl print
	ldr r0,=_enter_string
	bl puts
	.word 0xdeadc0de
	ldr pc,=main

.align 4
halt:
	b halt
	
_test_string:
	.string "test1\n"
	



	
	

	


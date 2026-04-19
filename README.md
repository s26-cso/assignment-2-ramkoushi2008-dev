[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


2.
riscv64-linux-gnu-gcc q2.s -o programd
gcc q2.s -o program
./program
3.
riscv64-linux-gnu-objdump -d target_ramkoushi2008-dev | grep -i -B2 -A20 "<main>"
python3 -u "/home/ram-kowshik/Desktop/cso/assignment-2-ramkoushi2008-dev/q3/b/1.py"
qemu-riscv64 ./target_ramkoushi2008-dev < payload.bin
4.

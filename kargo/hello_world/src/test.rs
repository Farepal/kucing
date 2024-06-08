use std::mem;

pub fn test() {
    let x = "qasdjasfhlajshdjladlkajskldhalhdwouhihilwa".to_string();
    let x_ptr = &x as *const String;
    let x_addr = x_ptr as usize;
    let x_size = mem::size_of_val(&x);

    println!("Variable x: {}", x);
    println!("Address of x: {:p}", x_ptr);
    println!("Address (usize) of x: {:#x}", x_addr);
    println!("Size of x: {} bytes", x_size);
}

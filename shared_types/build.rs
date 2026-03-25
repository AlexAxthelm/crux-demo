use crux_core::typegen::TypeGen;
use shared::{CruxDemo, ScreenViewModel};
use std::path::PathBuf;

fn main() -> anyhow::Result<()> {
    println!("cargo:rerun-if-changed=../shared");

    let mut gen = TypeGen::new();

    gen.register_app::<CruxDemo>()?;
    // Required because the reflection library can't automatically find
    // enum types nested inside other types
    gen.register_type::<ScreenViewModel>()?;

    let output_root = PathBuf::from("./generated");

    gen.swift("SharedTypes", output_root.join("swift"))?;

    Ok(())
}

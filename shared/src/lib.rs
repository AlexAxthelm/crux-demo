// shared/src/lib.rs
pub mod app;

use std::sync::LazyLock;
pub use crux_core::{bridge::{Bridge, EffectId}, Core, Request};
pub use app::*;

#[cfg(not(target_family = "wasm"))]
uniffi::include_scaffolding!("shared");

static CORE: LazyLock<Bridge<Counter>> = LazyLock::new(|| Bridge::new(Core::new()));

#[must_use]
pub fn process_event(data: &[u8]) -> Vec<u8> {
    let mut out = Vec::new();
    CORE.update(data, &mut out).expect("update failed");
    out
}

#[must_use]
pub fn handle_response(id: u32, data: &[u8]) -> Vec<u8> {
    let mut out = Vec::new();
    CORE.resolve(EffectId(id), data, &mut out).expect("resolve failed");
    out
}

#[must_use]
pub fn view() -> Vec<u8> {
    let mut out = Vec::new();
    CORE.view(&mut out).expect("view failed");
    out
}

use crux_core::{
    macros::effect,
    render::{self, RenderOperation},
    App, Command,
};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum Event {
    NavigateToSettings,
    NavigateToLibrary,
}

#[effect(typegen)]
pub enum Effect {
    Render(RenderOperation),
}

#[derive(Default)]
pub struct Model {
    current_screen: Screen,
}

#[derive(Default, PartialEq)]
pub enum Screen {
    #[default]
    Library,
    Settings,
}

pub fn placeholder_feeds() -> Vec<FeedViewModel> {
    vec![
        FeedViewModel {
            id: "feed-1".to_string(),
            title: "Rustacean Station".to_string(),
            episode_count: 3,
        },
        FeedViewModel {
            id: "feed-2".to_string(),
            title: "The Changelog".to_string(),
            episode_count: 5,
        },
        FeedViewModel {
            id: "feed-3".to_string(),
            title: "Software Unscripted".to_string(),
            episode_count: 2,
        },
    ]
}

// --- ViewModels (public, serializable, cross FFI) ---

#[derive(Serialize, Deserialize, Clone, Default, Debug)]
pub struct ViewModel {
    pub current_screen: ScreenViewModel,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub enum ScreenViewModel {
    Library(LibraryViewModel),
    Settings,
}

impl Default for ScreenViewModel {
    fn default() -> Self {
        ScreenViewModel::Library(LibraryViewModel {
            feeds: placeholder_feeds(),
        })
    }
}

#[derive(Serialize, Deserialize, Clone, Debug, Default)]
pub struct LibraryViewModel {
    pub feeds: Vec<FeedViewModel>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct FeedViewModel {
    pub id: String,
    pub title: String,
    pub episode_count: u32,
}
#[derive(Default)]
pub struct CruxDemo;

impl App for CruxDemo {
    type Event = Event;
    type Model = Model;
    type ViewModel = ViewModel;
    type Effect = Effect;

    fn update(&self, event: Event, model: &mut Model) -> Command<Effect, Event> {
        match event {
            Event::NavigateToSettings => {
                model.current_screen = Screen::Settings;
            }
            Event::NavigateToLibrary => {
                model.current_screen = Screen::Library;
            }
        }
        render::render()
    }

    fn view(&self, model: &Self::Model) -> Self::ViewModel {
        let current_screen = match model.current_screen {
            Screen::Library => ScreenViewModel::Library(LibraryViewModel {
                feeds: placeholder_feeds(),
            }),
            Screen::Settings => ScreenViewModel::Settings,
        };

        ViewModel { current_screen }
    }
}

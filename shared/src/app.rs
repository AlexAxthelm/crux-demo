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
    NavigateToFeedDetail(String),
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
    FeedDetail(String)
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

pub fn placeholder_feed_detail(feed_id: &str) -> FeedDetailViewModel {
    let (title, episodes) = match feed_id {
        "feed-1" => ("Rustacean Station", vec![
            EpisodeViewModel { id: "e-1-1".to_string(), title: "Rust 2024 Edition".to_string(), duration: "62 min".to_string() },
            EpisodeViewModel { id: "e-1-2".to_string(), title: "Async Rust".to_string(), duration: "48 min".to_string() },
            EpisodeViewModel { id: "e-1-3".to_string(), title: "Building with Crux".to_string(), duration: "55 min".to_string() },
        ]),
        "feed-2" => ("The Changelog", vec![
            EpisodeViewModel { id: "e-2-1".to_string(), title: "Open Source in 2025".to_string(), duration: "71 min".to_string() },
            EpisodeViewModel { id: "e-2-2".to_string(), title: "The State of Rust".to_string(), duration: "58 min".to_string() },
            EpisodeViewModel { id: "e-2-3".to_string(), title: "WebAssembly Today".to_string(), duration: "44 min".to_string() },
            EpisodeViewModel { id: "e-2-4".to_string(), title: "AI and Open Source".to_string(), duration: "66 min".to_string() },
            EpisodeViewModel { id: "e-2-5".to_string(), title: "Scaling Developer Tools".to_string(), duration: "52 min".to_string() },
        ]),
        _ => ("Unknown Feed", vec![]),
    };

    FeedDetailViewModel {
        id: feed_id.to_string(),
        title: title.to_string(),
        episodes,
    }
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
    FeedDetail(FeedDetailViewModel),
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

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct FeedDetailViewModel {
    pub id: String,
    pub title: String,
    pub episodes: Vec<EpisodeViewModel>,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct EpisodeViewModel {
    pub id: String,
    pub title: String,
    pub duration: String,
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
            Event::NavigateToFeedDetail(feed_id) => {
                model.current_screen = Screen::FeedDetail(feed_id);
            }
        }
        render::render()
    }

    fn view(&self, model: &Self::Model) -> Self::ViewModel {
        let current_screen = match &model.current_screen {
            Screen::Library => ScreenViewModel::Library(LibraryViewModel {
                feeds: placeholder_feeds(),
            }),
            Screen::Settings => ScreenViewModel::Settings,
            Screen::FeedDetail(feed_id) => ScreenViewModel::FeedDetail(placeholder_feed_detail(&feed_id))
        };

        ViewModel { current_screen }
    }
}

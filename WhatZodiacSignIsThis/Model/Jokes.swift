//
//  Jokes.swift
//  WhatZodiacSignIsThis
//
//  Created by MyMac on 8/31/23.
//

import Foundation

// A jokes dictionary that will accept a String for the key and an array of Strings for the values
struct Jokes {
    
    static let shared = Jokes()
    
    let jokesArray: [String: [String]] = [
        "AriesButton": [
            "I don't wait for elevators; I take the stairs. Who has time to stand around?",
            "New restaurant? I'm there! I live for taste adventures.",
            "Sports? I don't just watch; I compete with the players from my couch!",
            "Personal trainer? Nah, I'm the life coach of my own journey!",
            "A rock band? Count me in! I've got enough energy to light up a stadium!"
        ],
        "TaurusButton": [
            "Buffet? That's where I set up camp, sampling all the delights.",
            "Puzzle? I won't quit until every piece finds its place!",
            "Movie night? Classic films, cozy blankets, and my comfort zone intact.",
            "Gardening? I'm in. The patience for growth runs in my roots.",
            "Umbrella? Always ready. I'm the dependable one in every storm."
        ],
        "GeminiButton": [
            "Texting? I could have a full conversation before you finish your sentence!",
            "Music? I've got playlists for every mood and scenario.",
            "Indecisiveness? I've mastered the art of keeping options open.",
            "Two-faced? Nah, I'm just well-equipped for different situations.",
            "Socializing? I thrive in crowds and can charm anyone within seconds."
        ],
        "CancerButton": [
            "Home is where the heart is, and my heart is always in my cozy sanctuary.",
            "Sentimental? My keepsake box is a treasure trove of memories.",
            "Intuition? I trust my gut feelings more than anything else.",
            "Family time? My calendar is blocked for quality bonding moments.",
            "Empathy? I've got a radar for everyone's emotions, even the cat's."
        ],
        "LeoButton": [
            "Spotlight? Just follow the crowd's applause; I'm the center of attention.",
            "Drama? Life is my stage, and I'm the star of every scene.",
            "Generosity? I give, and people can't help but love me for it.",
            "Confidence? I'm not just self-assured; I'm practically radiating it.",
            "Roar? It's not just a sound; it's my majestic presence announcing itself."
        ],
        "VirgoButton": [
            "Did you see that organized closet? Yep, that's my masterpiece.",
            "Perfectionism? I'm not obsessed; I just want everything flawless.",
            "Routine? My schedule is a work of art, down to the minute.",
            "Detail-oriented? I spot what others miss; it's a gift and a curse.",
            "Analyzing? I can dissect a situation until every angle is explored."
        ],
        "LibraButton": [
            "Decision-making? Let's consult a committee before I choose.",
            "Balance? It's not just a yoga pose; it's my life philosophy.",
            "Harmony? I'm like a mediator superhero, always restoring peace.",
            "Social gatherings? I orchestrate events like a seasoned conductor.",
            "Flirting? I'm not just charming; I've mastered the art of attraction."
        ],
        "ScorpioButton": [
            "Secrets? They're safe with me. I'm like a vault of mysteries.",
            "Intense? My emotions run deep, and I don't hold back.",
            "Detective skills? I can uncover the truth even in the shadows.",
            "Passion? It's not just a word; it's the fire that fuels my every move.",
            "Transformation? I embrace change like a phoenix rising from ashes."
        ],
        "SagittariusButton": [
            "Wanderlust? You bet! My passport is always ready for an adventure.",
            "Philosophy? I ponder life's big questions while others are still waking up.",
            "Optimism? I'm not just hopeful; I see the silver lining everywhere.",
            "Adventure? My bucket list is as long as my tales of epic journeys.",
            "Freedom? I can't be caged; I'm the free spirit of the zodiac."
        ],
        "CapricornButton": [
            "Goal-setting? I don't just climb; I conquer mountains.",
            "Ambition? My dreams have a GPS, and I'm heading straight there.",
            "Workaholic? It's not just a job; it's my legacy in the making.",
            "Responsibility? I'm the reliable one people turn to in any crisis.",
            "Discipline? I'm not just organized; I'm a master of self-control."
        ],
        "AquariusButton": [
            "Rules? I'd rather invent new ones and see where they take us.",
            "Innovation? I'm not just creative; I'm a visionary thinker.",
            "Humanitarian? I can't help but fight for a better world.",
            "Rebellion? It's not just a phase; it's my lifelong outlook.",
            "Individuality? I march to my own beat, and the parade follows."
        ],
        "PiscesButton": [
            "Dreams? I dive into them and swim in my imagination.",
            "Intuition? I sense things others miss, like a psychic without the crystal ball.",
            "Empathy? I feel for everyone, even fictional characters on TV.",
            "Creativity? I'm not just artistic; my ideas come from cosmic inspiration.",
            "Daydreaming? It's not a distraction; it's where my magic happens."
        ]
    ]
    
}

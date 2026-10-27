-- =============================================================================
-- Database & Schema Setup
-- =============================================================================
CREATE DATABASE IF NOT EXISTS WHITECAPS_DEMO_DB;
CREATE SCHEMA IF NOT EXISTS WHITECAPS_DEMO_DB.BRONZE_RAW;
CREATE SCHEMA IF NOT EXISTS WHITECAPS_DEMO_DB.SILVER_CURATED;

USE DATABASE WHITECAPS_DEMO_DB;
USE SCHEMA BRONZE_RAW;

-- =============================================================================
-- Bronze Table DDL: RAW_MATCH_FEED (Semi-Structured VARIANT payload)
-- =============================================================================
CREATE OR REPLACE TABLE WHITECAPS_DEMO_DB.BRONZE_RAW.RAW_MATCH_FEED (
    FEED_ID VARCHAR(50),
    INGESTED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    SOURCE_SYSTEM VARCHAR(50),
    PAYLOAD VARIANT
);

-- =============================================================================
-- Synthetic Data Ingestion
-- =============================================================================
INSERT INTO WHITECAPS_DEMO_DB.BRONZE_RAW.RAW_MATCH_FEED (FEED_ID, SOURCE_SYSTEM, PAYLOAD)
SELECT 
    column1 AS FEED_ID,
    column2 AS SOURCE_SYSTEM,
    PARSE_JSON(column3) AS PAYLOAD
FROM VALUES
(
    'FEED-2026-001',
    'OPTA_EVENTS',
    '{
        "match_id": "M-2026-031",
        "match_date": "2026-03-15",
        "opponent": "Seattle Sounders",
        "venue": "BC Place",
        "attendance": 28450,
        "team": {
            "name": "Vancouver Whitecaps FC",
            "formation": "3-4-2-1"
        },
        "events": [
            {
                "event_id": "EV-1001",
                "minute": 14,
                "second": 22,
                "type": "Pass",
                "player_id": "P-101",
                "player_name": "Ryan Gauld",
                "position": "CAM",
                "success": true,
                "coordinates": {"x": 65.4, "y": 42.1},
                "tags": ["key_pass", "progressive"]
            },
            {
                "event_id": "EV-1002",
                "minute": 18,
                "second": 45,
                "type": "Shot",
                "player_id": "P-102",
                "player_name": "Brian White",
                "position": "ST",
                "success": true,
                "xg": 0.42,
                "outcome": "Goal",
                "coordinates": {"x": 88.2, "y": 36.5},
                "tags": ["goal", "header"]
            },
            {
                "event_id": "EV-1003",
                "minute": 32,
                "second": 10,
                "type": "Tackle",
                "player_id": "P-103",
                "player_name": "Andres Cubas",
                "position": "CDM",
                "success": true,
                "coordinates": {"x": 45.1, "y": 50.2},
                "tags": ["turnover_won", "duel"]
            },
            {
                "event_id": "EV-1004",
                "minute": 67,
                "second": 58,
                "type": "Shot",
                "player_id": "P-101",
                "player_name": "Ryan Gauld",
                "position": "CAM",
                "success": false,
                "xg": 0.18,
                "outcome": "Saved",
                "coordinates": {"x": 78.9, "y": 40.1},
                "tags": ["on_target"]
            }
        ],
        "player_stats": [
            {
                "player_id": "P-101",
                "player_name": "Ryan Gauld",
                "position": "CAM",
                "minutes_played": 90,
                "distance_km": 11.4,
                "sprints": 28,
                "rating": 8.7
            },
            {
                "player_id": "P-102",
                "player_name": "Brian White",
                "position": "ST",
                "minutes_played": 78,
                "distance_km": 9.8,
                "sprints": 34,
                "rating": 8.1
            },
            {
                "player_id": "P-103",
                "player_name": "Andres Cubas",
                "position": "CDM",
                "minutes_played": 90,
                "distance_km": 12.1,
                "sprints": 19,
                "rating": 7.9
            }
        ]
    }'
),
(
    'FEED-2026-002',
    'OPTA_EVENTS',
    '{
        "match_id": "M-2026-032",
        "match_date": "2026-03-22",
        "opponent": "Portland Timbers",
        "venue": "Providence Park",
        "attendance": 25218,
        "team": {
            "name": "Vancouver Whitecaps FC",
            "formation": "3-4-2-1"
        },
        "events": [
            {
                "event_id": "EV-2001",
                "minute": 8,
                "second": 15,
                "type": "Pass",
                "player_id": "P-101",
                "player_name": "Ryan Gauld",
                "position": "CAM",
                "success": true,
                "coordinates": {"x": 58.1, "y": 33.4},
                "tags": ["cross", "box_entry"]
            },
            {
                "event_id": "EV-2002",
                "minute": 24,
                "second": 50,
                "type": "Shot",
                "player_id": "P-104",
                "player_name": "Pedro Vite",
                "position": "CAM",
                "success": true,
                "xg": 0.28,
                "outcome": "Goal",
                "coordinates": {"x": 82.5, "y": 45.0},
                "tags": ["goal", "left_foot"]
            },
            {
                "event_id": "EV-2003",
                "minute": 54,
                "second": 12,
                "type": "Interception",
                "player_id": "P-105",
                "player_name": "Tristan Blackmon",
                "position": "CB",
                "success": true,
                "coordinates": {"x": 30.2, "y": 60.8},
                "tags": ["defensive_action"]
            },
            {
                "event_id": "EV-2004",
                "minute": 89,
                "second": 03,
                "type": "Foul",
                "player_id": "P-103",
                "player_name": "Andres Cubas",
                "position": "CDM",
                "success": false,
                "coordinates": {"x": 48.0, "y": 22.1},
                "tags": ["yellow_card"]
            }
        ],
        "player_stats": [
            {
                "player_id": "P-101",
                "player_name": "Ryan Gauld",
                "position": "CAM",
                "minutes_played": 90,
                "distance_km": 10.9,
                "sprints": 25,
                "rating": 7.8
            },
            {
                "player_id": "P-104",
                "player_name": "Pedro Vite",
                "position": "CAM",
                "minutes_played": 70,
                "distance_km": 8.9,
                "sprints": 29,
                "rating": 8.3
            },
            {
                "player_id": "P-103",
                "player_name": "Andres Cubas",
                "position": "CDM",
                "minutes_played": 90,
                "distance_km": 11.8,
                "sprints": 17,
                "rating": 7.2
            },
            {
                "player_id": "P-105",
                "player_name": "Tristan Blackmon",
                "position": "CB",
                "minutes_played": 90,
                "distance_km": 9.5,
                "sprints": 14,
                "rating": 7.6
            }
        ]
    }'
),
(
    'FEED-2026-003',
    'OPTA_EVENTS',
    '{
        "match_id": "M-2026-033",
        "match_date": "2026-03-29",
        "opponent": "LAFC",
        "venue": "BC Place",
        "attendance": 27890,
        "team": {
            "name": "Vancouver Whitecaps FC",
            "formation": "3-5-2"
        },
        "events": [
            {
                "event_id": "EV-3001",
                "minute": 5,
                "second": 40,
                "type": "Save",
                "player_id": "P-106",
                "player_name": "Yohei Takaoka",
                "position": "GK",
                "success": true,
                "coordinates": {"x": 5.2, "y": 39.8},
                "tags": ["diving_save"]
            },
            {
                "event_id": "EV-3002",
                "minute": 41,
                "second": 19,
                "type": "Shot",
                "player_id": "P-102",
                "player_name": "Brian White",
                "position": "ST",
                "success": true,
                "xg": 0.55,
                "outcome": "Goal",
                "coordinates": {"x": 91.0, "y": 38.2},
                "tags": ["goal", "tap_in"]
            },
            {
                "event_id": "EV-3003",
                "minute": 63,
                "second": 44,
                "type": "Pass",
                "player_id": "P-104",
                "player_name": "Pedro Vite",
                "position": "CAM",
                "success": true,
                "coordinates": {"x": 70.2, "y": 25.6},
                "tags": ["through_ball", "assist"]
            }
        ],
        "player_stats": [
            {
                "player_id": "P-106",
                "player_name": "Yohei Takaoka",
                "position": "GK",
                "minutes_played": 90,
                "distance_km": 4.5,
                "sprints": 3,
                "rating": 8.4
            },
            {
                "player_id": "P-102",
                "player_name": "Brian White",
                "position": "ST",
                "minutes_played": 85,
                "distance_km": 10.2,
                "sprints": 38,
                "rating": 8.5
            },
            {
                "player_id": "P-104",
                "player_name": "Pedro Vite",
                "position": "CAM",
                "minutes_played": 90,
                "distance_km": 11.1,
                "sprints": 31,
                "rating": 8.0
            }
        ]
    }'
);

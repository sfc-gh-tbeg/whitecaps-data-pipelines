-- =============================================================================
-- Silver Schema Setup
-- =============================================================================
CREATE SCHEMA IF NOT EXISTS WHITECAPS_DEMO_DB.SILVER_CURATED;

USE DATABASE WHITECAPS_DEMO_DB;
USE SCHEMA SILVER_CURATED;

-- =============================================================================
-- Dynamic Table 1: DT_MATCH_EVENTS
-- Flattens semi-structured match events from RAW_MATCH_FEED
-- =============================================================================
CREATE OR REPLACE DYNAMIC TABLE WHITECAPS_DEMO_DB.SILVER_CURATED.DT_MATCH_EVENTS
  TARGET_LAG = '1 minute'
  WAREHOUSE = COMPUTE_WH
AS
SELECT 
    f.FEED_ID,
    f.INGESTED_AT,
    f.SOURCE_SYSTEM,
    f.PAYLOAD:match_id::VARCHAR(50) AS MATCH_ID,
    f.PAYLOAD:match_date::DATE AS MATCH_DATE,
    f.PAYLOAD:opponent::VARCHAR(100) AS OPPONENT,
    f.PAYLOAD:venue::VARCHAR(100) AS VENUE,
    f.PAYLOAD:attendance::NUMBER AS ATTENDANCE,
    f.PAYLOAD:team.name::VARCHAR(100) AS TEAM_NAME,
    f.PAYLOAD:team.formation::VARCHAR(20) AS FORMATION,
    e.value:event_id::VARCHAR(50) AS EVENT_ID,
    e.value:minute::NUMBER AS EVENT_MINUTE,
    e.value:second::NUMBER AS EVENT_SECOND,
    e.value:type::VARCHAR(50) AS EVENT_TYPE,
    e.value:player_id::VARCHAR(50) AS PLAYER_ID,
    e.value:player_name::VARCHAR(100) AS PLAYER_NAME,
    e.value:position::VARCHAR(20) AS PLAYER_POSITION,
    e.value:success::BOOLEAN AS IS_SUCCESSFUL,
    e.value:xg::FLOAT AS EXPECTED_GOALS,
    e.value:outcome::VARCHAR(50) AS OUTCOME,
    e.value:coordinates.x::FLOAT AS COORD_X,
    e.value:coordinates.y::FLOAT AS COORD_Y,
    e.value:tags::ARRAY AS EVENT_TAGS
FROM WHITECAPS_DEMO_DB.BRONZE_RAW.RAW_MATCH_FEED f,
LATERAL FLATTEN(input => f.PAYLOAD:events) e;

-- =============================================================================
-- Dynamic Table 2: DT_PLAYER_MATCH_STATS
-- Flattens semi-structured player match statistics from RAW_MATCH_FEED
-- =============================================================================
CREATE OR REPLACE DYNAMIC TABLE WHITECAPS_DEMO_DB.SILVER_CURATED.DT_PLAYER_MATCH_STATS
  TARGET_LAG = '1 minute'
  WAREHOUSE = COMPUTE_WH
AS
SELECT 
    f.FEED_ID,
    f.INGESTED_AT,
    f.SOURCE_SYSTEM,
    f.PAYLOAD:match_id::VARCHAR(50) AS MATCH_ID,
    f.PAYLOAD:match_date::DATE AS MATCH_DATE,
    f.PAYLOAD:opponent::VARCHAR(100) AS OPPONENT,
    f.PAYLOAD:venue::VARCHAR(100) AS VENUE,
    p.value:player_id::VARCHAR(50) AS PLAYER_ID,
    p.value:player_name::VARCHAR(100) AS PLAYER_NAME,
    p.value:position::VARCHAR(20) AS PLAYER_POSITION,
    p.value:minutes_played::NUMBER AS MINUTES_PLAYED,
    p.value:distance_km::FLOAT AS DISTANCE_KM,
    p.value:sprints::NUMBER AS TOTAL_SPRINTS,
    p.value:rating::FLOAT AS MATCH_RATING
FROM WHITECAPS_DEMO_DB.BRONZE_RAW.RAW_MATCH_FEED f,
LATERAL FLATTEN(input => f.PAYLOAD:player_stats) p;

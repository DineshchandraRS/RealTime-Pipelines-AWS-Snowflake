create database spotify_db;

create or replace storage integration s3_init
    type = external_stage
    storage_provider =  S3
    enabled = TRUE
    storage_aws_role_arn = 'arn:aws:iam::982534387834:role/spotify-spark-snowflake-role'
    storage_allowed_locations = ('s3://spotify-etl-project-dinesh')
    comment = 'Creating connection to s3';

desc integration s3_init

create or replace file format csv_fileformat
    type = 'csv'
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL', 'Null')
    empty_field_as_null = true
    field_optionally_enclosed_by = '"';

create or replace stage spotify_stage
    url = 's3://spotify-etl-project-dinesh/transformed_data'
    storage_integration = s3_init
    file_format = csv_fileformat

list @spotify_stage/songs_data;

create or replace table tbl_album(
    album_id string,
    album_name string,
    album_release_date date,
    album_total_tracks bigint,
    album_external_urls string
);

create or replace table tbl_artist(
    artist_id string,
    artist_name string,
    artist_external_url string
);

create or replace table tbl_songs(
    song_id string,
    song_name string,
    duration_ms bigint,
    url string,
    popularity bigint,
    song_added date,
    album_id string,
    artist_id string
);

copy into tbl_album
from @spotify_stage/album_data;

select * from tbl_album;

copy into tbl_artist
from @spotify_stage/artist_data;

select * from tbl_artist;

copy into tbl_songs
from @spotify_stage/songs_data;

select * from tbl_songs;

create or replace schema pipe;

create or replace pipe spotify_db.pipe.tbl_album_pipe
auto_ingest = true
as
copy into spotify_db.public.tbl_album
from @spotify_db.public.spotify_stage/album_data;

create or replace pipe spotify_db.pipe.tbl_artist_pipe
auto_ingest = true
as
copy into spotify_db.public.tbl_artist
from @spotify_db.public.spotify_stage/artist_data;

create or replace pipe spotify_db.pipe.tbl_songs_pipe
auto_ingest = true
as
copy into spotify_db.public.tbl_songs
from @spotify_db.public.spotify_stage/songs_data;

desc pipe pipe.tbl_album_pipe;

desc pipe pipe.tbl_artist_pipe;

desc pipe pipe.tbl_songs_pipe;

select count(*) from tbl_album;

select count(*) from tbl_artist;

select count(*) from tbl_songs;

select system$pipe_status('pipe.tbl_songs_pipe')


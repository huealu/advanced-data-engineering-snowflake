USE ROLE accountadmin;
CREATE DATABASE course_repo;
USE SCHEMA public;

-- Create credentials
CREATE OR REPLACE SECRET course_repo.public.github_pat
  TYPE = password
  USERNAME = 'huealu'  -- Your GitHub username
  PASSWORD = ''; -- Your GitHub personal access token
  -- How to set up a GitHub personal access token: 
  -- link: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
  -- profile -> setting -> developer settings 
  -- -> personal access tokens -> fine-grained tokens 
  -- -> generate new token -> add name for token 
  -- Repository: let all access -> expiration -> select scopes (repo)
  -- Repository permissions: contents: read and write
  -- Generate token and copy it to the PASSWORD field above


-- Create the API integration
CREATE OR REPLACE API INTEGRATION git_api_integration
  API_PROVIDER = git_https_api
  API_ALLOWED_PREFIXES = ('https://github.com/huealu') -- URL to your GitHub profile
  -- The line above will allow the access to all repositories under the specified GitHub repo URL.
  ALLOWED_AUTHENTICATION_SECRETS = (github_pat)
  ENABLED = TRUE;

-- Create the git repository object
CREATE OR REPLACE GIT REPOSITORY course_repo.public.advanced_data_engineering_snowflake
  API_INTEGRATION =  git_api_integration -- Name of the API integration defined above
  ORIGIN = '' -- Insert URL of forked repo
  -- The line above: spcify the path to the GitHub repo that you forked. 
  GIT_CREDENTIALS = course_repo.public.github_pat;

-- List the git repositories
SHOW GIT REPOSITORIES;
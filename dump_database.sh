#!/bin/sh

set -u
set -e

root="$(dirname "${0}")"

mysqldump --skip-opt -d osu \
  migrations \
  osu_achievements \
  osu_apikeys \
  osu_beatmaps \
  osu_beatmapsets \
  osu_changelog \
  osu_countries \
  osu_login_attempts \
  osu_user_achievements \
  osu_user_banhistory \
  osu_user_stats \
  osu_user_stats_fruits \
  osu_user_stats_mania \
  osu_user_stats_taiko \
  osu_username_change_history \
  phpbb_acl_groups \
  phpbb_disallow \
  phpbb_forums \
  phpbb_posts \
  phpbb_ranks \
  phpbb_smilies \
  phpbb_topics \
  phpbb_topics_track \
  phpbb_user_group \
  phpbb_users \
  tournament_registrations \
  tournaments \
  user_profile_customizations \
> "${root}/db-osu-structure.sql"

mysqldump -d --skip-opt osu_store \
  addresses \
  order_items \
  orders \
  products \
> "${root}/db-osu_store-structure.sql"

mysqldump -t --skip-opt osu \
  migrations \
> "${root}/db-osu-data.sql"

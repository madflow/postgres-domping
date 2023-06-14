create extension if not exists pg_cron;
create extension if not exists http;

create table if not exists targets (
    id serial primary key,
    name text not null,
    url text not null,
    created_at timestamp with time zone not null default now()
);
create unique index if not exists targets_url_unique on targets (url);

drop trigger if exists new_target on targets;
drop function if exists register_target;
drop trigger if exists new_notification on cron.job_run_details;
drop function if exists send_notification;

create function register_target() returns trigger as $register_target$
    begin
perform cron.schedule(
    new.name, -- name of the cron job
    '* * * * *', -- every minute
format(
    $$
    select status
    from
      http_get(%L)
    $$, new.url)
  );
        return new;
    end;
$register_target$ language plpgsql;

create or replace trigger new_target
after insert on targets
for each row
execute function register_target();


create function send_notification() returns trigger as $send_notification$
    declare
      slack_url varchar;
    begin
        slack_url := current_setting('domping.slack_channel_url')::varchar;
        if new.status = 'failed' then
          perform http_post(slack_url, row_to_json(new)::varchar, 'application/json');
        end if;
        return new;
    end;
$send_notification$ language plpgsql;

create or replace trigger new_notification
after update on cron.job_run_details
for each row
execute function send_notification();

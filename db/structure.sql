CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "email" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "password_digest" varchar NOT NULL, "remember_digest" varchar /*application='SampleApp'*/, "admin" boolean DEFAULT 0 /*application='SampleApp'*/, "activation_digest" varchar /*application='SampleApp'*/, "activated" boolean DEFAULT 0 /*application='SampleApp'*/, "activated_at" datetime(6) /*application='SampleApp'*/, "reset_digest" varchar /*application='SampleApp'*/, "reset_sent_at" datetime(6) /*application='SampleApp'*/);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email") /*application='SampleApp'*/;
CREATE TABLE IF NOT EXISTS "microposts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "content" text, "user_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, "picture" varchar /*application='SampleApp'*/, CONSTRAINT "fk_rails_558c81314b"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_microposts_on_user_id" ON "microposts" ("user_id") /*application='SampleApp'*/;
CREATE INDEX "index_microposts_on_user_id_and_created_at" ON "microposts" ("user_id", "created_at") /*application='SampleApp'*/;
CREATE TABLE IF NOT EXISTS "relationships" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "follower_id" integer NOT NULL, "followed_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_8c9a6d4759"
FOREIGN KEY ("follower_id")
  REFERENCES "users" ("id")
 ON DELETE CASCADE, CONSTRAINT "fk_rails_9f3075433a"
FOREIGN KEY ("followed_id")
  REFERENCES "users" ("id")
 ON DELETE CASCADE);
CREATE INDEX "index_relationships_on_follower_id" ON "relationships" ("follower_id") /*application='SampleApp'*/;
CREATE INDEX "index_relationships_on_followed_id" ON "relationships" ("followed_id") /*application='SampleApp'*/;
CREATE UNIQUE INDEX "index_relationships_on_follower_id_and_followed_id" ON "relationships" ("follower_id", "followed_id") /*application='SampleApp'*/;
CREATE TABLE IF NOT EXISTS "likes" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "micropost_id" integer NOT NULL, "like_at" datetime(6) DEFAULT CURRENT_TIMESTAMP NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_1e09b5dabf"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_e86cbd10de"
FOREIGN KEY ("micropost_id")
  REFERENCES "microposts" ("id")
);
CREATE INDEX "index_likes_on_user_id" ON "likes" ("user_id") /*application='SampleApp'*/;
CREATE INDEX "index_likes_on_micropost_id" ON "likes" ("micropost_id") /*application='SampleApp'*/;
CREATE UNIQUE INDEX "index_likes_on_user_id_and_micropost_id" ON "likes" ("user_id", "micropost_id") /*application='SampleApp'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20250114142325'),
('20250112110318'),
('20250112100633'),
('20250112051921'),
('20250108135432'),
('20250105090337'),
('20250104080133'),
('20250104031757'),
('20250102064401'),
('20241201130109'),
('20241201124647'),
('20241130152645');


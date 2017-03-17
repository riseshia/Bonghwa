# frozen_string_literal: true
namespace :frontend do
  desc "Deploy webpack based-front end"
  task :deploy do
    on roles(:app) do
      frontend_path = release_path.join("frontend")
      from_static_path = frontend_path.join("dist", "static")
      dest_static_path = release_path.join("public", "static")
      from_index_path = frontend_path.join("dist", "index.html")
      dest_index_path = release_path.join("app", "views", "frontend", "index.html")

      within frontend_path do
        execute :yarn
        execute :yarn, "run build"
        execute :ln, "-s #{from_static_path} #{dest_static_path}"
        execute :ln, "-s #{from_index_path} #{dest_index_path}"
      end
    end
  end
end

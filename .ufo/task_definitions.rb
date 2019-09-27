# There some built-in helpers that are automatically available in this file.
#
# Some of helpers get data from the Dockerfile and some are from other places.
# Here's a summary of the some helpers:
#
#   helper.full_image_name 
#   helper.dockerfile_port
#   helper.env_vars(text)
#   helper.env_file(path)
#   helper.current_region
#
# More info: http://ufoships.com/docs/helpers/
#
task_definition "heimdall-web" do
  source "fargate" # will use ufo/templates/fargate.json.erb
  variables(
    family: task_definition_name,
    name: "web",
    container_port: helper.dockerfile_port,
    # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
    # Strongly recommended to use CloudWatch/centralized logging.
    # Ufo automatically creates the log group as part of deployment.
    #
    # More info on awslogs settings: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/using_awslogs.html
    # The log stream takes the following format:
    #   prefix-name/container-name/ecs-task-id
    # Here's an exmaple when you specify the prefix of "demo"
    #   demo/web/209e93b4-5523-4496-9a27-662fd151eb78
    awslogs_group: ["ecs/heimdall-web", Ufo.env_extra].compact.join('-'),
    awslogs_stream_prefix: "heimdall",
    awslogs_region: helper.current_region,
    command: ["/bin/sh","-c","./bin/web"] # IMPORTANT: change or create a bin/web file
  )
end

# task_definition "heimdall-db-migrate" do
#   source "fargate" # will use ufo/templates/fargate.json.erb
#   variables(
#     family: task_definition_name,
#     name: "db-migrate",
#     # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
#     awslogs_group: ["ecs/heimdall-db-migrate", Ufo.env_extra].compact.join('-'),
#     awslogs_stream_prefix: "heimdall",
#     awslogs_region: helper.current_region,
#     command: ["/bin/sh","-c","./bin/db_migrate"]
#   )
# end

# task_definition "heimdall-db-setup" do
#   source "fargate" # will use ufo/templates/fargate.json.erb
#   variables(
#     family: task_definition_name,
#     name: "db-setup",
#     # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
#     awslogs_group: ["ecs/heimdall-db-setup", Ufo.env_extra].compact.join('-'),
#     awslogs_stream_prefix: "heimdall",
#     awslogs_region: helper.current_region,
#     command: ["/bin/sh","-c","./bin/db_setup"]
#   )
# end

# task_definition "heimdall-db-reset" do
#   source "fargate" # will use ufo/templates/fargate.json.erb
#   variables(
#     family: task_definition_name,
#     name: "db-reset",
#     # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
#     awslogs_group: ["ecs/heimdall-db-reset", Ufo.env_extra].compact.join('-'),
#     awslogs_stream_prefix: "heimdall",
#     awslogs_region: helper.current_region,
#     command: ["/bin/sh","-c","./bin/db_reset"]
#   )
# end

# task_definition "heimdall-worker" do
#   source "fargate" # will use ufo/templates/fargate.json.erb
#   variables(
#     family: task_definition_name,
#     name: "worker",
#     # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
#     awslogs_group: ["ecs/heimdall-worker", Ufo.env_extra].compact.join('-'),
#     awslogs_stream_prefix: "heimdall",
#     awslogs_region: helper.current_region,
#     # command: ["bin/worker"] # IMPORTANT: change or create a bin/worker file
#   )
# end

# task_definition "heimdall-clock" do
#   source "fargate" # will use ufo/templates/fargate.json.erb
#   variables(
#     family: task_definition_name,
#     name: "clock",
#     # Comment out awslogs_* if you do not want logs to be sent to CloudWatch.
#     awslogs_group: ["ecs/heimdall-clock", Ufo.env_extra].compact.join('-'),
#     awslogs_stream_prefix: "heimdall",
#     awslogs_region: helper.current_region,
#     # command: ["bin/clock"] # IMPORTANT: change or create a bin/clock file
#   )
# end

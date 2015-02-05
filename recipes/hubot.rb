docker_image "cataska/hubot-slack"

docker_container "cataska/hubot-slack" do
  detach true
  env "HUBOT_SLACK_TOKEN=#{node[:jtalks][:hubot][:token]}"
end
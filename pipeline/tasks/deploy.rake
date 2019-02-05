desc 'Deploy Grafana'
task :deploy do
  puts 'deploy ecs cloudformation template'
  stack_name = 'GRAFANA-ECS'

  subnet1 = @keystore.retrieve('PRIVATE_SUBNET_1')
  subnet2 = @keystore.retrieve('PRIVATE_SUBNET_2')
  subnet3 = @keystore.retrieve('PRIVATE_SUBNET_3')

  parameters = {
    'StackName' => stack_name,
    'VpcId' => 'vpc-123456',
    'AsgSubnets' => [subnet1, subnet2, subnet3].join(','),
    'SubnetId' => '',
    'DesiredCapacity' => '1',
    'MaxSize' => '1',
    'InstanceType' => 'm4.large',
    'ContainerName' => 'grafana',
    'CpuReservation' => '512',
    'MemoryReservation' => '1024',
    'KeyName' => @keystore.retrieve('SSH_KEYNAME'),
    "ImageName" => 'grafana/grafana'
  }

  @cloudformation.deploy_stack(
    stack_name,
    parameters,
    'provisioning/ecs.yml'
  )
  puts 'done!'
end

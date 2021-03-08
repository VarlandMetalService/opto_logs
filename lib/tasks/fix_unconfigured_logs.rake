desc 'Fixes unconfigured logs'
task :fix_unconfigured_logs => :environment do
  OptoLog.fix_unconfigured
end
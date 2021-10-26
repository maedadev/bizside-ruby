require 'bizside/cron_validator'

module Bizside
  class JobUtils

    def self.add_job(klass, *args, &block)
      add_job_to(nil, klass, *args, &block)
    end

    def self.add_job_to(queue, klass, *args)
      if Bizside.rails_env&.test?
        if klass.respond_to?(:before_enqueue)
          return unless klass.before_enqueue(*args)
        end

        Bizside.logger.info "テスト時にはジョブの登録を行わず、即時実行します。"
        klass.perform(*args)
        return
      end

      if block_given?
        yield
      else
        if queue
          Bizside.logger.info "ジョブ #{klass} を #{queue} に登録します。"
        else
          Bizside.logger.info "ジョブ #{klass} を登録します。"
        end
      end

      if queue.present?
        ::Resque.enqueue_to(queue, klass, *args)
      else
        ::Resque.enqueue(klass, *args)
      end
    end

    def self.add_job_silently(klass, *args)
      add_job(klass, *args) do
        # 何も出力しない
      end
    end

    def self.add_job_silently_to(queue, klass, *args)
      add_job_to(queue, klass, *args) do
        # 何も出力しない
      end
    end

    def self.set_job_at(time, klass, *args)
      if Bizside.rails_env&.test?
        if klass.respond_to?(:before_enqueue)
          return unless klass.before_enqueue(*args)
        end

        Bizside.logger.info "テスト時には遅延ジョブの登録を行わず、即時実行します。"
        klass.perform(*args)
        return
      end

      if block_given?
        yield
      else
        Bizside.logger.info "遅延ジョブ #{klass} を登録します。"
      end

      ::Resque.enqueue_at(time, klass, *args)
    end

    def self.set_job_silently_at(time, klass, *args)
      set_job_at(time, klass, *args) do
        # 何も出力しない
      end
    end

    def self.cancel_job_at(klass, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info "テスト時には遅延ジョブのキャンセルを行いません。"
        return
      end

      ::Resque.remove_delayed(klass, *args)
    end

    def self.add_cron(name, job_type, cron, *args)
      add_cron_to(nil, name, job_type, cron, *args)
    end

    def self.add_cron_to(queue, name, job_type, cron, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にはCronの設定を行いません。'
        return
      end

      ::Resque.remove_schedule(name)

      cronline = Array(cron).first

      if cronline.to_s.strip.empty?
        return
      elsif CronValidator.new(cronline).valid?
        config = {
          :class => job_type,
          :cron => cron,
          :args => args,
          :persist => true
        }

        config[:queue] = queue if queue.present?

        ::Resque.set_schedule(name, config)
      else
        raise ArgumentError, "Cronの書式が正しくないのでスケジューリングしません。name=#{name}"
      end
    end

    def self.remove_cron(name)
      remove_scheduler(name)
    end

    def self.add_scheduler(name, job_type, interval_args, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にはCronの設定を行いません。'
        return
      end

      ::Resque.remove_schedule(name)

      if interval_args[:cron].present?
        add_cron(name, job_type, interval_args[:cron], args)
      elsif interval_args[:every].present?
        config = {
          :class => job_type,
          :every => interval_args[:every],
          :args => args,
          :persist => true
        }
        ::Resque.set_schedule(name, config)
      else
        raise ArgumentError, "cronもしくはeveryが指定されていないのでスケジューリングしません。name=#{name}"
      end
    end

    def self.remove_scheduler(name)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にはCronの設定を行いません。'
        return
      end

      ::Resque.remove_schedule(name)
    end

    def self.peek(queue, start = 0, count = 1)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時は、ジョブ 0 件とします。'
        return []
      end

      ::Resque.peek(queue, start, count)
    end

    def self.enqueue_in(time_to_delay, klass, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にジョブの遅延実行は行いません。'
        return
      end

      ::Resque.enqueue_in(time_to_delay, klass, *args)
    end

    def self.enqueue_in_with_queue(queue, time_to_delay, klass, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にジョブの遅延実行は行いません。'
        return
      end

      ::Resque.enqueue_in_with_queue(queue, time_to_delay, klass, *args)
    end

    def self.dequeue(klass, *args)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にジョブの削除は行いません。'
        return
      end

      ::Resque.dequeue(klass, *args)
    end

    def self.any_jobs_for?(queue)
      ret = ::Resque.size(queue)
      ret += ::Resque.working.reduce(0){|sum, worker| sum += worker.queues.include?(queue) ? 1 : 0 }
      ret > 0
    end

    def self.remove_queue(queue)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時にキューの削除は行いません。'
        return
      end

      ::Resque.remove_queue(queue)
    end

    def self.queue_from_class(klass)
      ::Resque.queue_from_class(klass)
    end

    def self.queue_size(queue)
      return 0 if Bizside.rails_env&.test?

      ::Resque.size(queue)
    end

    def self.unique_in_queue?(klass, args = {}, queue, count: 100, except: [])
      if Bizside.rails_env&.test?
        Bizside.logger.info "テスト時は常にキューに同一ジョブが存在しない前提とします。"
        return true
      end

      jobs = self.peek(queue, 0, count)  # 先頭からcount件のジョブ

      if already_in_jobs?(klass, args, jobs, except: except)
        false
      else
        count = rest_count(self.queue_size(queue), count)
        if count == 0
          true
        else
          count += 1 if count == 1  # Resque.peek()が1件だと戻り値の型が違うのを回避
          jobs = self.peek(queue, count * -1, count)  # 後ろからcount件のジョブ
          ! already_in_jobs?(klass, args, jobs, except: except)
        end
      end
    end

    def self.already_in_jobs?(klass, args = {}, jobs, except: [])
      args_to_check = args.with_indifferent_access.except(*Array(except))

      jobs.each do |hash|
        hash = hash.with_indifferent_access
        next unless hash['class'] == klass.to_s

        args = Hash(hash['args'].present? ? hash['args'][0] : {}).with_indifferent_access.except(*Array(except))
        next unless args.size == args_to_check.size

        found = true
        args_to_check.each do |key, value|
          if args[key] != value
            found = false
            break
          end
        end

        if found
          Bizside.logger.info "キューに #{hash} がすでに登録されています。"
          return true
        end
      end

      false
    end
    private_class_method :already_in_jobs?

    def self.rest_count(size, limit)
      [[size - limit, 0].max, limit].min
    end
    private_class_method :rest_count

    def self.failure_jobs(start = 0, count = 1, queue = nil)
      if Bizside.rails_env&.test?
        Bizside.logger.info 'テスト時は、ジョブ 0 件とします。'
        return []
      end

      ::Resque::Failure.all(start, count, queue)
    end

    def self.failure_count(queue = nil, class_name = nil)
      return 0 if Bizside.rails_env&.test?

      ::Resque::Failure.count(queue, class_name)
    end

  end
end

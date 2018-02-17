require "granite_orm/adapter/pg"

class Host < Granite::ORM::Base
  extend Query::BuilderMethods

  adapter pg
  table_name :hosts

  field address : String
  field ip_version : String
  timestamps

  belongs_to :domain
  has_many :monitor_results

  before_create :guess_version
  before_destroy :destroy_associations

  def v4?
    version == "ipv4"
  end

  def v5?
    false
  end

  def v6?
    version == "ipv6"
  end

  def monitor_results
    MonitorResult.where(host_id: id)
  end

  def last_result
    @last_result ||= begin
      if result = monitor_results.order(created_at: :desc).first
        result
      else
        MonitorResult.new
      end
    end
  end

  def up?
    success, failure, total = last_result_summary
    success == total
  end

  def partial_up?
    success, failure, total = last_result_summary
    success > 0 && failure > 0
  end

  def down?
    ! up?
  end

  @last_results_grouped_by_success : Hash(Bool, Array(MonitorResult))?
  @last_results_grouped_by_type : Hash(String, Array(MonitorResult))?
  @found_last_results = false

  def last_results_grouped_by_type
    @last_results_grouped_by_type ||= begin
      grouped_results = last_result.matching_result_set.select.group_by(&.monitor_type)
      grouped_last_results = {} of String => Array(MonitorResult)
      MonitorResult::VALID_TYPES.values.each do |type|
        if grouped_results[type]?
          grouped_last_results[type] = grouped_results[type]
        end
      end
      grouped_last_results
    end
  end

  def last_results_grouped_by_success
    @last_results_grouped_by_success ||= begin
      grouped_results = last_result.matching_result_set.select.group_by(&.ok)
      grouped_last_results = {} of Bool => Array(MonitorResult)
      grouped_last_results[true]  = grouped_results[true]?  || [] of MonitorResult
      grouped_last_results[false] = grouped_results[false]? || [] of MonitorResult
      grouped_last_results
    end
  end

  def last_result_summary
    {
      last_results_grouped_by_success[true].size,
      last_results_grouped_by_success[false].size,
      last_result.matching_result_set.size
    }
  end

  def destroy_associations
    monitor_results.delete
  end

  def guess_version
    if address = @address
      @ip_version = address.includes?(":") ? "ipv6" : "ipv4"
    end
  end
end

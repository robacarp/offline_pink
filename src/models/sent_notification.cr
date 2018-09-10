class SentNotification < Granite::Base
  extend Granite::Query::BuilderMethods

  adapter pg
  table_name :sent_notifications

  primary id : Int64
  field reason_code : Int32
  field vendor_code : Int32
  belongs_to :user
  timestamps



  enum Reason
    Undefined
    Verification
    Downtime
  end

  def reasonify(r : Symbol) : Reason
    Reason.parse r.to_s
  end

  def reason : Reason
    if code = @reason_code
      Reason.new code
    else
      Reason::Undefined
    end
  end

  def reason=(r : Symbol) : Reason
    self.reason = reasonify r
  end

  def reason=(r : Reason) : Reason
    self.reason_code = r.to_i
    r
  end




  enum Vendor
    Undefined
    Pushover
    Slack
  end

  def vendorify(v : Symbol) : Vendor
    Vendor.parse v.to_s
  end

  def vendor : Vendor
    if code = @vendor_code
      Vendor.new code
    else
      Vendor::Undefined
    end
  end

  def vendor=(v : Symbol) : Vendor
    self.vendor = vendorify v
  end

  def vendor=(v : Vendor) : Vendor
    self.vendor_code = v.to_i
    v
  end
end

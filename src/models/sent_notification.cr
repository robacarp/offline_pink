class SentNotification < Granite::Base
  extend Granite::Query::BuilderMethods

  adapter pg
  primary id : Int64
  field reason_code : Int32
  field vendor_code : Int32
  belongs_to :user
  timestamps



  enum Reason
    Verification = 1
    Downtime
  end

  def reasonify(r : Symbol) : Reason
    Reason.parse r.to_s
  end

  def reason : Reason
    Reason.parse self.reason_code
  end

  def reason=(r : Symbol) : Reason
    reason = reasonify r
  end

  def reason=(r : Reason) : Reason
    self.reason_code = r.to_i
    r
  end




  enum Vendor
    Pushover = 1
    Slack = 2
  end

  def vendorify(v : Symbol) : Vendor
    Vendor.parse v.to_s
  end

  def vendor : Vendor
    Vendor.parse self.vendor_code
  end

  def vendor=(v : Symbol) : Vendor
    vendor = vendorify v
  end

  def vendor=(v : Vendor) : Vendor
    self.vendor_code = v.to_i
    v
  end
end

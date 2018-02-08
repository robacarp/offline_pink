# .count
# .where(field: value).count
# .where(field: value).order(...).count
require "../spec_helper"
require "spec"

require "db"
require "../../../../src/ext/query_builder"

class Model
  def self.table_name
    "table"
  end

  def self.fields
    ["name", "age"]
  end

  def self.primary_name
    "id"
  end
end

def query_fields
  [Model.primary_name, Model.fields].flatten.join ", "
end

def builder
  builder = Query::Builder(Model).new
end

def assembler
  Query::Assembler::Postgresql(Model).new builder
end

def ignore_whitespace(expected : String)
  whitespace = "\\s+"
  compiled = expected.split(/\s/).map {|s| Regex.escape s }.join(whitespace)
  Regex.new compiled, Regex::Options::IGNORE_CASE ^ Regex::Options::MULTILINE
end

describe Query::Assembler::Postgresql(Model) do
  context "count" do
    it "adds group_by fields for where/count queries" do
      sql = "select count(*) from table where name = $1 group by name"
      builder.where(name: "bob").count.raw_sql.should match ignore_whitespace sql
    end

    it "counts without group_by fields for simple counts" do
      builder.count.raw_sql.should match ignore_whitespace "select count(*) from table"
    end
  end

  context "where" do
    it "properly numbers fields" do
      sql = "select #{query_fields} from table where name = $1 and age = $2 order by id desc"
      builder.where(name: "bob", age: "23").raw_sql.should match ignore_whitespace sql
    end
  end

  context "order" do
    it "uses default sort when no sort is provided" do
      builder.raw_sql.should match ignore_whitespace "select #{query_fields} from table order by id desc"
    end

    it "uses specified sort when provided" do
      sql = "select #{query_fields} from table order by id asc"
      builder.order(id: :asc).raw_sql.should match ignore_whitespace sql
    end
  end
end

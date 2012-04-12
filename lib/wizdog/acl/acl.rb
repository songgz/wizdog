# To change this template, choose Tools | Templates
# and open the template in the editor.
module WizAcl
  class Acl
    @@serialize_path = File.join(File.dirname(__FILE__),"..","..","acl.yml")
    attr_accessor :entries
    def initialize
        @entries = []
        @entries << WizAcl::Entry.new("*", "*").deny("*")
        #{aco_id => {:instance => aro, :parents => {prent_id => parent}, :children => {aro_id => aro}}}
        @aros = {}
        #{:instance => aco, :parent => aco_parent, :children => {}}
        @acos = {}
    end
    
    def self.instance
        #unserialize
        @@__acl__ ||=new
    end

    def self.authorize(&block)
      block.call(instance)
    end

    def self.unserialize
      YAML.load_file(@@serialize_path)
    end
    
    def self.serialize
      File.open(@@serialize_path,"w") do |io|
         YAML.dump(@@__acl__, io)
      end
    end

    def self.serialize_path=(path)
      @@serialize_path = path
    end

    def add_aro(aro, parents = "*")
      aro_id = aro.respond_to?(:aro_id) ? aro.aro_id.to_s : aro.to_s
      @aros[aro_id] = @aros[aro_id] || {:instance => Aro.new(aro_id), :parents =>{}, :children =>{}}

      parents = [parents] unless parents.is_a?(Array)
      parents.each do |parent|
        parent_id = parent.respond_to?(:aro_id) ? parent.aro_id.to_s : parent.to_s
        @aros[parent_id] = @aros[parent_id] || {:instance => Aro.new(parent_id),:parents =>{}, :children =>{}}
        @aros[aro_id][:parents][parent_id] = @aros[aro_id][:parents][parent_id] || @aros[parent_id][:instance]
        @aros[parent_id][:children][aro_id] = @aros[aro_id][:children][aro_id] || @aros[aro_id][:instance]
      end

    end

    def add_aco(aco, parents = "*")
      aco = Aco.new(aco) unless aco.respond_to?(:aco_id)

      @acos[aco.aco_id] = {:instance => aco, :parents =>{}, :children =>{}}

      parents = [parents] unless parents.is_a?(Array)
      parents.each do |parent|
        parent = Aco.new(parent) unless parent.respond_to?(:aco_id)
        @acos[parent.aco_id] = @acos[parent.aco_id] || {:instance => parent,:parents =>{}, :children =>{}}
        @acos[aco.aco_id][:parents][parent.aco_id] = @acos[parent.aco_id][:instance]
        @acos[parent.aco_id][:children][aco.aco_id] = @acos[aco.aco_id][:instance]
      end
    end

    def get_aco(id)
      @acos[id][:instance]
    end

    def get_parents_of_aco(id)
      @acos[id][:parents].values
    end

    def get_children_of_aco(id)
      @acos[id] ? @acos[id][:children].values : []
    end

    def allow(aros = "*", acos = "*", operations = "*")
      aros = [aros] unless aros.is_a?(Array)
      acos = [acos] unless acos.is_a?(Array)
      aros.each do |aro|
        acos.each do |aco|
          entry = find_one_entry(aro, aco)
          entry.nil? ? @entries << WizAcl::Entry.new(aro, aco).allow(operations) : entry.allow(operations)
        end
      end
    end

    def deny(aros = "*", acos = "*", operations = "*")
      aros = [aros] unless aros.is_a?(Array)
      acos = [acos] unless acos.is_a?(Array)
      aros.each do |aro|
        acos.each do |aco|
          entry = find_one_entry(aro, aco)
          entry.nil? ? @entries << WizAcl::Entry.new(aro, aco).deny(operations) : entry.deny(operations)
        end
      end
    end    

    def allowed?(aro = "*", aco = "*", operation = "*")     
      ###
      permit = dfs_permitted_by_aro(aro, aco, operation)
      return permit unless permit.nil?

      permit = permitted?("*", "*", operation)
      return permit unless permit.nil?
    end

    def remove_allow(aro = "*", aco = "*", operations = "*")
      entry = find_one_entry(aro,aco)
      if entry && entry.privileges[operations.to_s] == :allow
        entry.privileges.delete(operations.to_s)
        @entries.delete(entry) if entry.privileges.empty?
      end
    end

    def remove_deny(aro = "*", aco = "*", operations = "*")
      entry = find_one_entry(aro,aco)
      if entry && entry.privileges[operations.to_s] == :deny
        entry.privileges.delete(operations.to_s)
        @entries.delete(entry) if entry.privileges.empty?
      end
    end

    def find_entries_by_aro(aro)
      aro_id = aro.respond_to?(:aro_id) ? aro.aro_id.to_s : aro.to_s
      @entries.select { |e| e.aro_id == aro_id  }
    end

    def find_entries_by_aco(aco)
      aco_id = aco.respond_to?(:aco_id) ? aco.aco_id.to_s : aco.to_s
      @entries.select { |e| e.aco_id == aco_id  }
    end
    
    private

    def find_one_entry(aro = "*", aco = "*")
      aro_id = aro.respond_to?(:aro_id) ? aro.aro_id.to_s : aro.to_s
      aco_id = aco.respond_to?(:aco_id) ? aco.aco_id.to_s : aco.to_s
      @entries.detect() { |e| e.aro_id == aro_id && e.aco_id == aco_id }
    end

    def permitted?(aro = "*", aco = "*", operation = "*")
      entry = find_one_entry(aro, aco)
      permit = entry.allowed?(operation) unless entry.nil?
      return permit unless permit.nil?

      entry = find_one_entry(aro, "*")
      permit = entry.allowed?(operation) unless entry.nil?
      return permit unless permit.nil?

      entry = find_one_entry("*", aco)
      permit = entry.allowed?(operation) unless entry.nil?
      return permit unless permit.nil?

      nil
    end

   def find_all_parents_by_aro(aro = "*")
      aro_id = aro.respond_to?(:aro_id) ? aro.aro_id.to_s : aro.to_s
      parents = @aros[aro_id] || {}
      parents[:parents] || (aro.respond_to?(:aro_parents) ? aro.aro_parents : {})
   end

   def find_all_parents_by_aco(aco = "*")
      aco_id = aco.respond_to?(:aco_id) ? aco.aco_id.to_s : aco.to_s
      parents = @acos[aco_id] || {}
      parents[:parents] || (aco.respond_to?(:aco_parents) ? aco.aco_parents : {})
   end

    #dfs
    def dfs_permitted_by_aro(aro = "*", aco = "*", operation = "*")
      permit = permitted?(aro, aco, operation)
      return permit unless permit.nil?

      aco_parents = find_all_parents_by_aco(aco)
      aro_parents = find_all_parents_by_aro(aro)

      aro_parents.each do |aro_parent_id,aro_parent|
        permit = dfs_permitted_by_aro(aro_parent, aco, operation)
        return permit unless permit.nil?
      end

      aco_parents.each do |aco_parent_id, aco_parent|
        permit = dfs_permitted_by_aro(aro, aco_parent, operation)
        return permit unless permit.nil?
        aro_parents.each do |aro_parent_id,aro_parent|
          permit = dfs_permitted_by_aro(aro_parent, aco_parent, operation)
          return permit unless permit.nil?
        end
      end
      nil
    end

    #bfs
    def bfs_permitted_by_aro(aro = "*", aco = "*", operation = "*", queue = [])
      return nil if aro.nil?

      permit = permitted?(aro, aco, operation)
      return permit unless permit.nil?
      
      parents = find_all_parents_by_aro(aro)
      parents.each do |parent_id, parent|
        queue << parent_id
      end

      bfs_permitted_by_aro(queue.delete_at(0), aco, operation, queue)
    end
  end
end
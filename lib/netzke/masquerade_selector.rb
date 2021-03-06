module Netzke
  class MasqueradeSelector < TabPanel
    
    def items
      @items ||= [{
          :name              => "roles",
          :active            => true,
          :preloaded         => true,
          :widget_class_name => "GridPanel",
          :data_class_name   => 'Role',
          :columns           => [:id, :name],
          :bbar => false,
          :ext_config => {
            :title        => false
          }
        },{
          :name              => "users",
          :preloaded         => true,
          :widget_class_name    => "GridPanel", 
          :data_class_name      => 'User', 
          :bbar => false,
          :ext_config           => {
            :title        => false,
            :rows_per_page => 10
          },
          :columns => [:id, :login, :role__name]
      }]
    end

    def self.js_after_constructor
      <<-JS
        this.items.each(function(tab){
          tab.on('add', function(ct, cmp){
            cmp.on('rowclick', this.rowclickHandler, this);
          }, this);
        }, this)
      JS
    end

    def self.js_extend_properties
      super.merge({
        :rowclick_handler => <<-JS.l
          function(grid, rowIndex, e){
            var mode = grid.id.split("__").pop();
            var normMode = mode === 'users' ? 'user' : 'role';
            this.masquerade = {};
            this.masquerade[normMode] = grid.store.getAt(rowIndex).get('id');
          }
        JS
      })
    end

  end
end
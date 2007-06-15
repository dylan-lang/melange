/*
 *  gobject2-tool.c
 *
 *  gcc -o gobject2-tool gobject2-tool.c `pkg-config --cflags --libs gtk+-2.0`
 */

#include <gtk/gtk.h>


typedef GType (* GetTypeFunc) (void);


static void   query_type (GType type,
                          gint  level);


static GetTypeFunc get_type_funcs[] =
  {
    g_closure_get_type,
    g_value_get_type,
    g_value_array_get_type,
    g_date_get_type,
    g_strv_get_type,
    g_gstring_get_type,
    g_hash_table_get_type,
    g_initially_unowned_get_type,
    g_io_channel_get_type,
    g_io_condition_get_type,
    g_type_module_get_type,
    g_type_plugin_get_type,
    g_gtype_get_type,
    atk_action_get_type,
    atk_editable_text_get_type,
    atk_rectangle_get_type,
    atk_component_get_type,
    atk_document_get_type,
    atk_gobject_accessible_get_type,
    atk_hyperlink_get_type,
    atk_hypertext_get_type,
    atk_no_op_object_get_type,
    atk_no_op_object_factory_get_type,
    atk_object_get_type,
    atk_implementor_get_type,
    atk_object_factory_get_type,
    atk_image_get_type,
    atk_registry_get_type,
    atk_relation_get_type,
    atk_relation_set_get_type,
    atk_selection_get_type,
    atk_state_set_get_type,
    atk_streamable_content_get_type,
    atk_table_get_type,
    atk_text_get_type,
    atk_util_get_type,
    atk_value_get_type,
    pango_color_get_type,
    pango_attr_list_get_type,
    pango_context_get_type,
    pango_font_description_get_type,
    pango_font_metrics_get_type,
    pango_font_family_get_type,
    pango_font_face_get_type,
    pango_font_get_type,
    pango_font_map_get_type,
    pango_fontset_get_type,
    pango_glyph_string_get_type,
    pango_item_get_type,
    pango_layout_get_type,
    pango_layout_line_get_type,
    pango_layout_iter_get_type,
    pango_renderer_get_type,
    pango_tab_array_get_type,
    pango_matrix_get_type,
    pango_language_get_type,
    pango_attr_type_get_type,
    pango_underline_get_type,
    pango_coverage_level_get_type,
    pango_style_get_type,
    pango_variant_get_type,
    pango_weight_get_type,
    pango_stretch_get_type,
    pango_font_mask_get_type,
    pango_alignment_get_type,
    pango_wrap_mode_get_type,
    pango_ellipsize_mode_get_type,
    pango_render_part_get_type,
    pango_script_get_type,
    pango_tab_align_get_type,
    pango_direction_get_type,
    pango_cairo_font_map_get_type,
    gdk_pixbuf_get_type,
    gdk_pixbuf_simple_anim_get_type,
    gdk_pixbuf_simple_anim_iter_get_type,
    gdk_pixbuf_animation_get_type,
    gdk_pixbuf_animation_iter_get_type,
    gdk_pixbuf_alpha_mode_get_type,
    gdk_colorspace_get_type,
    gdk_pixbuf_error_get_type,
    gdk_interp_type_get_type,
    gdk_pixbuf_rotation_get_type,
    gdk_pixbuf_loader_get_type,
    gdk_rectangle_get_type,
    gdk_display_get_type,
    gdk_colormap_get_type,
    gdk_color_get_type,
    gdk_cursor_get_type,
    gdk_drawable_get_type,
    gdk_drag_context_get_type,
    gdk_event_get_type,
    gdk_font_get_type,
    gdk_gc_get_type,
    gdk_display_manager_get_type,
    gdk_image_get_type,
    gdk_device_get_type,
    gdk_keymap_get_type,
    gdk_pango_renderer_get_type,
    gdk_pixmap_get_type,
    gdk_screen_get_type,
    gdk_cursor_type_get_type,
    gdk_drag_action_get_type,
    gdk_drag_protocol_get_type,
    gdk_filter_return_get_type,
    gdk_event_type_get_type,
    gdk_event_mask_get_type,
    gdk_visibility_state_get_type,
    gdk_scroll_direction_get_type,
    gdk_notify_type_get_type,
    gdk_crossing_mode_get_type,
    gdk_property_state_get_type,
    gdk_window_state_get_type,
    gdk_setting_action_get_type,
    gdk_owner_change_get_type,
    gdk_font_type_get_type,
    gdk_cap_style_get_type,
    gdk_fill_get_type,
    gdk_function_get_type,
    gdk_join_style_get_type,
    gdk_line_style_get_type,
    gdk_subwindow_mode_get_type,
    gdk_gc_values_mask_get_type,
    gdk_image_type_get_type,
    gdk_extension_mode_get_type,
    gdk_input_source_get_type,
    gdk_input_mode_get_type,
    gdk_axis_use_get_type,
    gdk_prop_mode_get_type,
    gdk_fill_rule_get_type,
    gdk_overlap_type_get_type,
    gdk_rgb_dither_get_type,
    gdk_byte_order_get_type,
    gdk_modifier_type_get_type,
    gdk_input_condition_get_type,
    gdk_status_get_type,
    gdk_grab_status_get_type,
    gdk_visual_type_get_type,
    gdk_window_class_get_type,
    gdk_window_type_get_type,
    gdk_window_attributes_type_get_type,
    gdk_window_hints_get_type,
    gdk_window_type_hint_get_type,
    gdk_wm_decoration_get_type,
    gdk_wm_function_get_type,
    gdk_gravity_get_type,
    gdk_window_edge_get_type,
    gdk_visual_get_type,
    gdk_window_object_get_type,
    gtk_about_dialog_get_type,
    gtk_action_group_get_type,
    gtk_accel_group_get_type,
    gtk_accel_label_get_type,
    gtk_accel_map_get_type,
    gtk_accessible_get_type,
    gtk_action_get_type,
    gtk_aspect_frame_get_type,
    gtk_adjustment_get_type,
    gtk_alignment_get_type,
    gtk_arrow_get_type,
    gtk_bin_get_type,
    gtk_calendar_get_type,
    gtk_box_get_type,
    gtk_button_box_get_type,
    gtk_button_get_type,
    gtk_cell_renderer_combo_get_type,
    gtk_cell_editable_get_type,
    gtk_cell_layout_get_type,
    gtk_cell_renderer_get_type,
    gtk_cell_renderer_progress_get_type,
    gtk_cell_renderer_pixbuf_get_type,
    gtk_handle_box_get_type,
    gtk_cell_renderer_text_get_type,
    gtk_cell_renderer_toggle_get_type,
    gtk_cell_view_get_type,
    gtk_check_button_get_type,
    gtk_check_menu_item_get_type,
    gtk_clist_get_type,
    gtk_clipboard_get_type,
    gtk_color_button_get_type,
    gtk_color_selection_get_type,
    gtk_color_selection_dialog_get_type,
    gtk_combo_get_type,
    gtk_combo_box_get_type,
    gtk_combo_box_entry_get_type,
    gtk_container_get_type,
    gtk_ctree_get_type,
    gtk_ctree_node_get_type,
    gtk_curve_get_type,
    gtk_dialog_get_type,
    gtk_drawing_area_get_type,
    gtk_editable_get_type,
    gtk_entry_get_type,
    gtk_entry_completion_get_type,
    gtk_event_box_get_type,
    gtk_expander_get_type,
    gtk_file_chooser_get_type,
    gtk_file_chooser_button_get_type,
    gtk_file_chooser_dialog_get_type,
    gtk_file_chooser_widget_get_type,
    gtk_file_filter_get_type,
    gtk_file_selection_get_type,
    gtk_fixed_get_type,
    gtk_font_button_get_type,
    gtk_font_selection_get_type,
    gtk_font_selection_dialog_get_type,
    gtk_frame_get_type,
    gtk_gamma_curve_get_type,
    gtk_hscrollbar_get_type,
    gtk_hbutton_box_get_type,
    gtk_hbox_get_type,
    gtk_hpaned_get_type,
    gtk_hruler_get_type,
    gtk_hscale_get_type,
    gtk_icon_factory_get_type,
    gtk_icon_set_get_type,
    gtk_icon_source_get_type,
    gtk_hseparator_get_type,
    gtk_image_menu_item_get_type,
    gtk_icon_theme_get_type,
    gtk_icon_info_get_type,
    gtk_icon_view_get_type,
    gtk_image_get_type,
    gtk_im_context_simple_get_type,
    gtk_im_context_get_type,
    gtk_im_multicontext_get_type,
    gtk_radio_tool_button_get_type,
    gtk_input_dialog_get_type,
    gtk_invisible_get_type,
    gtk_item_get_type,
    gtk_item_factory_get_type,
    gtk_label_get_type,
    gtk_layout_get_type,
    gtk_list_get_type,
    gtk_list_item_get_type,
    gtk_list_store_get_type,
    gtk_menu_get_type,
    gtk_menu_bar_get_type,
    gtk_menu_item_get_type,
    gtk_menu_shell_get_type,
    gtk_menu_tool_button_get_type,
    gtk_message_dialog_get_type,
    gtk_misc_get_type,
    gtk_notebook_get_type,
    gtk_object_get_type,
    gtk_option_menu_get_type,
    gtk_paned_get_type,
    gtk_pixmap_get_type,
    gtk_plug_get_type,
    gtk_preview_get_type,
    gtk_progress_get_type,
    gtk_progress_bar_get_type,
    gtk_radio_action_get_type,
    gtk_radio_button_get_type,
    gtk_radio_menu_item_get_type,
    gtk_scrollbar_get_type,
    gtk_range_get_type,
    gtk_rc_style_get_type,
    gtk_ruler_get_type,
    gtk_scale_get_type,
    gtk_separator_menu_item_get_type,
    gtk_scrolled_window_get_type,
    gtk_selection_data_get_type,
    gtk_separator_get_type,
    gtk_separator_tool_item_get_type,
    gtk_settings_get_type,
    gtk_size_group_get_type,
    gtk_socket_get_type,
    gtk_spin_button_get_type,
    gtk_statusbar_get_type,
    gtk_style_get_type,
    gtk_border_get_type,
    gtk_table_get_type,
    gtk_tearoff_menu_item_get_type,
    gtk_text_buffer_get_type,
    gtk_text_child_anchor_get_type,
    gtk_text_iter_get_type,
    gtk_text_mark_get_type,
    gtk_text_tag_get_type,
    gtk_text_attributes_get_type,
    gtk_text_tag_table_get_type,
    gtk_text_view_get_type,
    gtk_tips_query_get_type,
    gtk_toggle_action_get_type,
    gtk_toggle_button_get_type,
    gtk_toggle_tool_button_get_type,
    gtk_toolbar_get_type,
    gtk_tool_button_get_type,
    gtk_tool_item_get_type,
    gtk_tooltips_get_type,
    gtk_tree_drag_source_get_type,
    gtk_tree_drag_dest_get_type,
    gtk_tree_path_get_type,
    gtk_tree_row_reference_get_type,
    gtk_tree_iter_get_type,
    gtk_tree_model_get_type,
    gtk_tree_model_filter_get_type,
    gtk_tree_model_sort_get_type,
    gtk_tree_selection_get_type,
    gtk_tree_sortable_get_type,
    gtk_tree_store_get_type,
    gtk_tree_view_get_type,
    gtk_tree_view_column_get_type,
    gtk_identifier_get_type,
    gtk_ui_manager_get_type,
    gtk_vbutton_box_get_type,
    gtk_vbox_get_type,
    gtk_viewport_get_type,
    gtk_vpaned_get_type,
    gtk_vruler_get_type,
    gtk_vscale_get_type,
    gtk_vscrollbar_get_type,
    gtk_vseparator_get_type,
    gtk_widget_get_type,
    gtk_requisition_get_type,
    gtk_window_get_type,
    gtk_window_group_get_type,
    gtk_accel_flags_get_type,
    gtk_calendar_display_options_get_type,
    gtk_cell_renderer_state_get_type,
    gtk_cell_renderer_mode_get_type,
    gtk_cell_type_get_type,
    gtk_clist_drag_pos_get_type,
    gtk_button_action_get_type,
    gtk_ctree_pos_get_type,
    gtk_ctree_line_style_get_type,
    gtk_ctree_expander_style_get_type,
    gtk_ctree_expansion_type_get_type,
    gtk_debug_flag_get_type,
    gtk_dialog_flags_get_type,
    gtk_response_type_get_type,
    gtk_dest_defaults_get_type,
    gtk_target_flags_get_type,
    gtk_anchor_type_get_type,
    gtk_arrow_type_get_type,
    gtk_attach_options_get_type,
    gtk_button_box_style_get_type,
    gtk_curve_type_get_type,
    gtk_delete_type_get_type,
    gtk_direction_type_get_type,
    gtk_expander_style_get_type,
    gtk_icon_size_get_type,
    gtk_side_type_get_type,
    gtk_text_direction_get_type,
    gtk_justification_get_type,
    gtk_match_type_get_type,
    gtk_menu_direction_type_get_type,
    gtk_metric_type_get_type,
    gtk_movement_step_get_type,
    gtk_scroll_step_get_type,
    gtk_orientation_get_type,
    gtk_corner_type_get_type,
    gtk_pack_type_get_type,
    gtk_path_priority_type_get_type,
    gtk_path_type_get_type,
    gtk_policy_type_get_type,
    gtk_position_type_get_type,
    gtk_preview_type_get_type,
    gtk_relief_style_get_type,
    gtk_resize_mode_get_type,
    gtk_signal_run_type_get_type,
    gtk_scroll_type_get_type,
    gtk_selection_mode_get_type,
    gtk_shadow_type_get_type,
    gtk_state_type_get_type,
    gtk_submenu_direction_get_type,
    gtk_submenu_placement_get_type,
    gtk_toolbar_style_get_type,
    gtk_update_type_get_type,
    gtk_visibility_get_type,
    gtk_window_position_get_type,
    gtk_window_type_get_type,
    gtk_wrap_mode_get_type,
    gtk_sort_type_get_type,
    gtk_im_preedit_style_get_type,
    gtk_im_status_style_get_type,
    gtk_pack_direction_get_type,
    gtk_file_chooser_action_get_type,
    gtk_file_chooser_confirmation_get_type,
    gtk_file_chooser_error_get_type,
    gtk_file_filter_flags_get_type,
    gtk_icon_lookup_flags_get_type,
    gtk_icon_theme_error_get_type,
    gtk_icon_view_drop_position_get_type,
    gtk_image_type_get_type,
    gtk_message_type_get_type,
    gtk_buttons_type_get_type,
    gtk_notebook_tab_get_type,
    gtk_object_flags_get_type,
    gtk_arg_flags_get_type,
    gtk_private_flags_get_type,
    gtk_progress_bar_style_get_type,
    gtk_progress_bar_orientation_get_type,
    gtk_rc_flags_get_type,
    gtk_rc_token_type_get_type,
    gtk_size_group_mode_get_type,
    gtk_spin_button_update_policy_get_type,
    gtk_spin_type_get_type,
    gtk_text_search_flags_get_type,
    gtk_text_window_type_get_type,
    gtk_toolbar_child_type_get_type,
    gtk_toolbar_space_style_get_type,
    gtk_tree_view_mode_get_type,
    gtk_tree_model_flags_get_type,
    gtk_tree_view_drop_position_get_type,
    gtk_tree_view_column_sizing_get_type,
    gtk_ui_manager_item_type_get_type,
    gtk_widget_flags_get_type,
    gtk_widget_help_type_get_type
  };


FILE* propfile;
FILE* propmodulefile;
int not_first = 0;

gint
main (gint   argc,
      gchar *argv[])
{
  gint  i;
  GType type;

  g_type_init ();

  propfile = g_fopen("properties.dylan", "w");
  propmodulefile = g_fopen("properties-module.dylan", "w");
  g_fprintf(propfile, "module: gtk-properties\n\n");
  g_fprintf(propmodulefile, 
	    "module: dylan-user\n\n"
	    "define module gtk-properties\n\n"
	    "  use common-dylan;\n"
	    "  use gtk-internal;\n\n"
            "  use gtk-support;\n\n"
	    "  export\n");

  g_print("module: gtk-internal\n\n"
          "define interface\n"
          "  #include \"gtk/gtk.h\",\n"
          "    import: all-recursive,\n"
	  "    name-mapper: minimal-name-mapping;\n");
  for (i = 0; i < G_N_ELEMENTS (get_type_funcs); i++)
    query_type (get_type_funcs[i] (), 0);
  g_print("end interface;");
  g_fprintf(propmodulefile, "  ;\nend\n");
  return 0;
}


/*  private functions  */

static inline void
indent (gint level)
{
  gint i;

  for (i = 0; i < level; i++)
    g_print ("  ");
}

static void
query_type (GType type,
            gint  level)
{
  indent (level);
  if (G_TYPE_IS_CLASSED (type))
    {

      GTypeQuery  type_query;
      GType      *interfaces;
      guint       n_interfaces;


      interfaces = g_type_interfaces (type, &n_interfaces);
      if ((n_interfaces > 0) | (g_type_is_a (type, G_TYPE_OBJECT)))
	{
	  g_print ("  struct \"struct _%s\",\n    superclasses: {",
		   g_type_name (type));
	  g_type_query (type, &type_query);

	  if (g_type_is_a (type, G_TYPE_OBJECT))
	    {
	      GTypeClass   *klass;
	      GObjectClass *object_class;
	      GType         parent;
	      
	      klass = g_type_class_ref (type);
	      
	      object_class = G_OBJECT_CLASS (klass);
	      
	      parent = g_type_parent(type);
	      
	      /*  query properties & signals here  */
	      
	      {
		guint        n_properties;
		GParamSpec** properties;
		guint        i;

		properties = g_object_class_list_properties(object_class, &n_properties);
		for(i = 0; i < n_properties; i++)
		  {
		    if (properties[i]->owner_type == type)
		      {
			if (properties[i]->flags & G_PARAM_READABLE)
			  {
			    g_fprintf(propfile,
				      "define property-getter %s :: <%s> on <%s> end;\n",
				      properties[i]->name,
				      g_type_name(properties[i]->value_type),
				      g_type_name(type));
			    if (not_first)
			      g_fprintf(propmodulefile, ",\n");
			    else
			      not_first = 23;
			    g_fprintf(propmodulefile, "    @%s", properties[i]->name);
			  }
			if (properties[i]->flags & G_PARAM_WRITABLE)
			  {
			    g_fprintf(propfile,
				      "define property-setter %s :: <%s> on <%s> end;\n",
				      properties[i]->name,
				      g_type_name(properties[i]->value_type),
				      g_type_name(type));
			    g_fprintf(propmodulefile, ",\n    @%s-setter", properties[i]->name);
			  }
			    
		      }
		  }

	      }
	      
	      /* query_type(parent, level + 1); */
	      
	      g_print("<_%s>", g_type_name (parent));
	      g_type_class_unref (klass);
	    }
	  
	  
	  if (n_interfaces > 0)
	    {
	      gint i;
	      
	      indent (level);
	      
	      for (i = 0; i < n_interfaces; i++)
		g_print (", <_%s>", g_type_name(interfaces[i]));
	      //query_type (interfaces[i], level + 1);
	    }
	  
	  g_print("};\n");
	}
      g_free (interfaces);
    }
}

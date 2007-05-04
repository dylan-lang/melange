module: gtk-internal

define interface
  #include "gtk/gtk.h",
    import: all-recursive,
    exclude: {
      "g_scanner_cur_value", // returns a union of size 8
      "glib_dummy_decl",
      "g_thread_init",
      "_g_param_type_register_static_constant",
      "g_thread_init_with_errorcheck_mutexes",
      "_gtk_container_clear_resize_widgets",
      "_gtk_accel_label_class_get_accelerator_label",
      "_gtk_accel_path_is_valid",
      "_gtk_accel_map_remove_group",
      "_gtk_accel_map_add_group",
      "_gtk_accel_map_init",
      "atk_hyperlink_impl_get_hyperlink",
      "atk_hyperlink_impl_get_type",
      "atk_streamable_content_get_uri",
      "atk_value_get_minimum_increment",
      "_gtk_binding_signal_new",
      "_gtk_binding_reset_parsed",
      "_gtk_combo_box_editing_canceled",
      "_gtk_clist_create_cell_layout",
      "_gtk_icon_factory_ensure_default_icons",
      "_gtk_icon_factory_list_ids",
      "_gtk_icon_set_invalidate_caches",
      "_gtk_icon_theme_ensure_builtin_cache",
      "_gtk_icon_theme_check_reload",
      "_gtk_menu_bar_cycle_focus",
      "_gtk_modules_settings_changed",
      "_gtk_modules_init",
      "_gtk_get_module_path",
      "_gtk_find_module",
      "_gtk_plug_remove_from_socket",
      "_gtk_plug_add_to_socket",
      "_gtk_get_lc_ctype",
      "_gtk_boolean_handled_accumulator",
      "_gtk_check_button_get_props",
      "_gtk_dialog_set_ignore_separator",
      "_gtk_scrolled_window_get_scrollbar_spacing",
      "_gtk_size_group_queue_resize",
      "_gtk_size_group_compute_requisition",
      "_gtk_size_group_get_child_requisition",
      "_gtk_clipboard_store_all",
      "_gtk_clipboard_handle_event",
      "_gtk_text_tag_table_remove_buffer",
      "_gtk_text_tag_table_add_buffer",
      "_gtk_text_buffer_notify_will_remove_tag",
      "_gtk_text_buffer_get_line_log_attrs",
      "_gtk_text_buffer_get_btree",
      "_gtk_text_buffer_spew",
      "_gtk_button_paint",
      "_gtk_button_set_depressed",
      "_gtk_toolbar_rebuild_menu",
      "_gtk_toolbar_get_default_space_size",
      "_gtk_toolbar_paint_space_line",
      "_gtk_toolbar_elide_underscores",
      "_gtk_tool_button_get_button",
      "_gtk_menu_item_popup_submenu",
      "_gtk_menu_item_is_selectable",
      "_gtk_menu_item_refresh_accel_path",
      "_gtk_tool_item_toolbar_reconfigured",
      "_gtk_tooltips_toggle_keyboard_mode",
      "_gtk_selection_property_notify",
      "_gtk_selection_notify",
      "_gtk_selection_incr_event",
      "_gtk_selection_request",
      "_gtk_drag_dest_handle_event",
      "_gtk_drag_source_handle_event",
      "_gtk_menu_shell_remove_mnemonic",
      "_gtk_menu_shell_add_mnemonic",
      "_gtk_menu_shell_get_popup_delay",
      "_gtk_menu_shell_activate",
      "_gtk_menu_shell_select_last",
      "_gtk_action_sync_menu_visible",
      "_gtk_action_sync_visible",
      "_gtk_action_sync_sensitive",
      "_gtk_action_emit_activate",
      "_gtk_action_group_emit_post_activate",
      "_gtk_action_group_emit_pre_activate",
      "_gtk_action_group_emit_disconnect_proxy",
      "_gtk_action_group_emit_connect_proxy",
      "_gtk_button_box_child_requisition",
      "_gtk_scale_format_value",
      "_gtk_scale_get_value_size",
      "_gtk_scale_clear_layout",
      "_gtk_range_get_wheel_delta",
      "_gtk_container_focus_sort",
      "_gtk_container_dequeue_resize_handler",
      "_gtk_container_child_composite_name",
      "_gtk_container_queue_resize",
      "_gtk_accel_group_reconnect",
      "_gtk_accel_group_detach",
      "_gtk_accel_group_attach",
      "_wtmpnam",
      "_wtempnam",
      "_wremove",
      "_wpopen",
      "_wperror",
      "_wfreopen",
      "_wfopen",
      "_wfdopen",
      "wscanf",
      "swscanf",
      "fwscanf",
      "vswprintf",
      "_vsnwprintf",
      "vwprintf",
      "vfwprintf",
      "swprintf",
      "_snwprintf",
      "wprintf",
      "fwprintf",
      "_putws",
      "_getws",
      "fputws",
      "fgetws",
      "ungetwc",
      "putwchar",
      "putwc",
      "getwchar",
      "getwc",
      "_fputwchar",
      "fputwc",
      "_fgetwchar",
      "fgetwc",
      "_wfsopen",
      "vsprintf",
      "_vsnprintf",
      "vprintf",
      "vfprintf",
      "_unlink",
      "ungetc",
      "tmpnam",
      "tmpfile",
      "_tempnam",
      "sscanf",
      "sprintf",
      "_snprintf",
      "setvbuf",
      "_setmaxstdio",
      "setbuf",
      "scanf",
      "_rmtmp",
      "rewind",
      "rename",
      "_putw",
      "puts",
      "putchar",
      "putc",
      "printf",
      "_popen",
      "_pclose",
      "perror",
      "_getw",
      "gets",
      "_getmaxstdio",
      "getchar",
      "getc",
      "fwrite",
      "ftell",
      "fseek",
      "fsetpos",
      "fscanf",
      "freopen",
      "fread",
      "fputs",
      "_fputchar",
      "fputc",
      "fprintf",
      "fopen",
      "_flushall",
      "fileno",
      "fgets",
      "fgetpos",
      "_fgetchar",
      "fgetc",
      "fflush",
      "ferror",
      "feof",
      "fdopen",
      "_fcloseall",
      "fclose",
      "clearerr",
      "_fsopen",
      "_flsbuf",
      "_filbuf",
      "_gtk_style_shade",
      "_gtk_style_init_for_settings",
      "_gtk_style_peek_property_value",
      "_gtk_rc_context_destroy",
      "_gtk_rc_context_get_default_font_name",
      "_gtk_rc_style_get_color_hashes",
      "_gtk_rc_style_lookup_rc_property",
      "_gtk_rc_match_widget_class",
      "_gtk_rc_free_widget_class_path",
      "_gtk_rc_parse_widget_class_path",
      "_gtk_rc_init",
      "_gtk_settings_parse_convert",
      "_gtk_rc_property_parser_from_type",
      "_gtk_settings_handle_event",
      "_gtk_settings_reset_rc_values",
      "_gtk_settings_set_property_value_from_rc",
      "_g_signals_destroy",
      "realloc",
      "malloc",
      "free",
      "calloc",
      "_g_async_queue_get_mutex",
      "_wstrtime",
      "_wstrdate",
      "wcsftime",
      "_wctime",
      "_wasctime",
      "_setsystime",
      "_getsystime",
      "tzset",
      "time",
      "_strtime",
      "_strdate",
      "strftime",
      "mktime",
      "localtime",
      "gmtime",
      "difftime",
      "clock",
      "ctime",
      "asctime",
      "g_debug",
      "g_warning",
      "g_critical",
      "g_message",
      "g_error",
      "_g_log_fallback_handler",
      "_g_utf8_make_valid",
      "atexit",
      "_g_getenv_nomalloc",
      "_statusfp",
      "_status87",
      "_clearfp",
      "_clear87",
      "_fpclass",
      "_isnan",
      "_finite",
      "_nextafter",
      "_logb",
      "_scalb",
      "_chgsign",
      "_copysign",
      "_control87",
      "_fpreset",
      "_controlfp",
      "g_signal_init",
      "g_value_transforms_init",
      "g_param_spec_types_init",
      "g_object_type_init",
      "g_boxed_type_init",
      "g_param_type_init",
      "g_enum_types_init",
      "g_value_types_init",
      "g_value_c_init",
      "_gtk_widget_peek_colormap",
      "_gtk_widget_propagate_composited_changed",
      "_gtk_widget_propagate_screen_changed",
      "_gtk_widget_propagate_hierarchy_changed",
      "_gtk_widget_get_aux_info",
      "_gtk_widget_grab_notify",
      "_gtk_widget_get_accel_path",
      "_gtk_window_query_nonaccels",
      "_gtk_window_keys_foreach",
      "_gtk_window_set_is_active",
      "_gtk_window_unset_focus_and_default",
      "_gtk_window_set_has_toplevel_focus",
      "_gtk_window_group_get_current_grab",
      "_gtk_window_constrain_size",
      "_gtk_window_reposition",
      "_gtk_window_internal_set_focus"
  	},
    map: {"gchar*" => <byte-string>,
          "char*" => <byte-string>,
          "GCallback" => <function>},
    rename: {"gtk_init" => %gtk-init },
    name-mapper: minimal-name-mapping;

  pointer "char**" => <c-string-vector>,
    superclasses: {<c-vector>};
  function "g_signal_connect_data",
    equate-argument: { 1 => <GObject>};
  function "g_signal_connect_closure",
    equate-argument: { 1 => <GObject>};
  function "g_closure_set_meta_marshal",
    map-argument: { 2 => <object> };
  function "g_closure_new_simple",
    map-argument: { 2 => <object> };
  struct "struct _GObject",
    superclasses: {<GTypeInstance>};
  struct "struct _GtkAccelGroup",
    superclasses: {<GObject>};
  struct "struct _GtkAccelLabel",
    superclasses: {<GtkLabel>, <AtkImplementorIface>};
  struct "struct _GtkAccessible",
    superclasses: {<AtkObject>};
  struct "struct _GtkAdjustment",
    superclasses: {<GtkObject>};
  struct "struct _GtkAlignment",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkArrow",
    superclasses: {<GtkMisc>, <AtkImplementorIface>};
  struct "struct _GtkAspectFrame",
    superclasses: {<GtkFrame>, <AtkImplementorIface>};
  struct "struct _GtkBin",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkBox",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkButtonBox",
    superclasses: {<GtkBox>, <AtkImplementorIface>};
  struct "struct _GtkButton",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkCalendar",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkCellRenderer",
    superclasses: {<GtkObject>};
  struct "struct _GtkCellRendererPixbuf",
    superclasses: {<GtkCellRenderer>};
  struct "struct _GtkCellRendererText",
    superclasses: {<GtkCellRenderer>};
  struct "struct _GtkCellRendererToggle",
    superclasses: {<GtkCellRenderer>};
  struct "struct _GtkCheckButton",
    superclasses: {<GtkToggleButton>, <AtkImplementorIface>};
  struct "struct _GtkCheckMenuItem",
    superclasses: {<GtkMenuItem>, <AtkImplementorIface>};
  struct "struct _GtkCList",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkColorSelectionDialog",
    superclasses: {<GtkDialog>, <AtkImplementorIface>};
  struct "struct _GtkColorSelection",
    superclasses: {<GtkVBox>, <AtkImplementorIface>};
  struct "struct _GtkCombo",
    superclasses: {<GtkHBox>, <AtkImplementorIface>};
  struct "struct _GtkContainer",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkCTree",
    superclasses: {<GtkCList>, <AtkImplementorIface>};
  struct "struct _GtkCurve",
    superclasses: {<GtkDrawingArea>, <AtkImplementorIface>};
  struct "struct _GtkDialog",
    superclasses: {<GtkWindow>, <AtkImplementorIface>};
  struct "struct _GtkDrawingArea",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkEntry",
    superclasses: {<GtkWidget>, <AtkImplementorIface>, <GtkEditable>, <GtkCellEditable>};
  struct "struct _GtkEventBox",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkFileSelection",
    superclasses: {<GtkDialog>, <AtkImplementorIface>};
  struct "struct _GtkFixed",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkFontSelectionDialog",
    superclasses: {<GtkDialog>, <AtkImplementorIface>};
  struct "struct _GtkFontSelection",
    superclasses: {<GtkVBox>, <AtkImplementorIface>};
  struct "struct _GtkFrame",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkGammaCurve",
    superclasses: {<GtkVBox>, <AtkImplementorIface>};
  struct "struct _GtkHandleBox",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkHBox",
    superclasses: {<GtkBox>, <AtkImplementorIface>};
  struct "struct _GtkHButtonBox",
    superclasses: {<GtkButtonBox>, <AtkImplementorIface>};
  struct "struct _GtkHPaned",
    superclasses: {<GtkPaned>, <AtkImplementorIface>};
  struct "struct _GtkHRuler",
    superclasses: {<GtkRuler>, <AtkImplementorIface>};
  struct "struct _GtkHScale",
    superclasses: {<GtkScale>, <AtkImplementorIface>};
  struct "struct _GtkHScrollbar",
    superclasses: {<GtkScrollbar>, <AtkImplementorIface>};
  struct "struct _GtkHSeparator",
    superclasses: {<GtkSeparator>, <AtkImplementorIface>};
  struct "struct _GtkIconFactory",
    superclasses: {<GObject>};
  struct "struct _GtkIMContext",
    superclasses: {<GObject>};
  struct "struct _GtkIMContextSimple",
    superclasses: {<GtkIMContext>};
  struct "struct _GtkIMMulticontext",
    superclasses: {<GtkIMContext>};
  struct "struct _GtkImage",
    superclasses: {<GtkMisc>, <AtkImplementorIface>};
  struct "struct _GtkImageMenuItem",
    superclasses: {<GtkMenuItem>, <AtkImplementorIface>};
  struct "struct _GtkInputDialog",
    superclasses: {<GtkDialog>, <AtkImplementorIface>};
  struct "struct _GtkInvisible",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkItemFactory",
    superclasses: {<GtkObject>};
  struct "struct _GtkItem",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkLabel",
    superclasses: {<GtkMisc>, <AtkImplementorIface>};
  struct "struct _GtkLayout",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkList",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkListItem",
    superclasses: {<GtkItem>, <AtkImplementorIface>};
  struct "struct _GtkListStore",
    superclasses: {<GObject>, <GtkTreeModel>, <GtkTreeDragSource>, <GtkTreeDragDest>, <GtkTreeSortable>};
  struct "struct _GtkMenuBar",
    superclasses: {<GtkMenuShell>, <AtkImplementorIface>};
  struct "struct _GtkMenu",
    superclasses: {<GtkMenuShell>, <AtkImplementorIface>};
  struct "struct _GtkMenuItem",
    superclasses: {<GtkItem>, <AtkImplementorIface>};
  struct "struct _GtkMenuShell",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkMessageDialog",
    superclasses: {<GtkDialog>, <AtkImplementorIface>};
  struct "struct _GtkMisc",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkNotebook",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkObject",
    superclasses: {<GObject>};
  struct "struct _GtkOptionMenu",
    superclasses: {<GtkButton>, <AtkImplementorIface>};
  struct "struct _GtkPaned",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkPixmap",
    superclasses: {<GtkMisc>, <AtkImplementorIface>};
  struct "struct _GtkPlug",
    superclasses: {<GtkWindow>, <AtkImplementorIface>};
  struct "struct _GtkPreview",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkProgressBar",
    superclasses: {<GtkProgress>, <AtkImplementorIface>};
  struct "struct _GtkProgress",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkRadioButton",
    superclasses: {<GtkCheckButton>, <AtkImplementorIface>};
  struct "struct _GtkRadioMenuItem",
    superclasses: {<GtkCheckMenuItem>, <AtkImplementorIface>};
  struct "struct _GtkRange",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkRcStyle",
    superclasses: {<GObject>};
  struct "struct _GtkRuler",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkScale",
    superclasses: {<GtkRange>, <AtkImplementorIface>};
  struct "struct _GtkScrollbar",
    superclasses: {<GtkRange>, <AtkImplementorIface>};
  struct "struct _GtkScrolledWindow",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkSeparator",
    superclasses: {<GtkWidget>, <AtkImplementorIface>};
  struct "struct _GtkSeparatorMenuItem",
    superclasses: {<GtkMenuItem>, <AtkImplementorIface>};
  struct "struct _GtkSettings",
    superclasses: {<GObject>};
  struct "struct _GtkSizeGroup",
    superclasses: {<GObject>};
  struct "struct _GtkSocket",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkSpinButton",
    superclasses: {<GtkEntry>, <AtkImplementorIface>, <GtkEditable>, <GtkCellEditable>};
  struct "struct _GtkStatusbar",
    superclasses: {<GtkHBox>, <AtkImplementorIface>};
  struct "struct _GtkStyle",
    superclasses: {<GObject>};
  struct "struct _GtkTable",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkTearoffMenuItem",
    superclasses: {<GtkMenuItem>, <AtkImplementorIface>};
  struct "struct _GtkTextBuffer",
    superclasses: {<GObject>};
  struct "struct _GtkTextChildAnchor",
    superclasses: {<GObject>};
  struct "struct _GtkTextMark",
    superclasses: {<GObject>};
  struct "struct _GtkTextTag",
    superclasses: {<GObject>};
  struct "struct _GtkTextTagTable",
    superclasses: {<GObject>};
  struct "struct _GtkTextView",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkTipsQuery",
    superclasses: {<GtkLabel>, <AtkImplementorIface>};
  struct "struct _GtkToggleButton",
    superclasses: {<GtkButton>, <AtkImplementorIface>};
  struct "struct _GtkToolbar",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkTooltips",
    superclasses: {<GtkObject>};
  struct "struct _GtkTreeModelSort",
    superclasses: {<GObject>, <GtkTreeModel>, <GtkTreeSortable>};
  struct "struct _GtkTreeSelection",
    superclasses: {<GObject>};
  struct "struct _GtkTreeStore",
    superclasses: {<GObject>, <GtkTreeModel>, <GtkTreeDragSource>, <GtkTreeDragDest>, <GtkTreeSortable>};
  struct "struct _GtkTreeViewColumn",
    superclasses: {<GtkObject>};
  struct "struct _GtkTreeView",
    superclasses: {<GtkContainer>, <AtkImplementorIface>};
  struct "struct _GtkVBox",
    superclasses: {<GtkBox>, <AtkImplementorIface>};
  struct "struct _GtkVButtonBox",
    superclasses: {<GtkButtonBox>, <AtkImplementorIface>};
  struct "struct _GtkViewport",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkVPaned",
    superclasses: {<GtkPaned>, <AtkImplementorIface>};
  struct "struct _GtkVRuler",
    superclasses: {<GtkRuler>, <AtkImplementorIface>};
  struct "struct _GtkVScale",
    superclasses: {<GtkScale>, <AtkImplementorIface>};
  struct "struct _GtkVScrollbar",
    superclasses: {<GtkScrollbar>, <AtkImplementorIface>};
  struct "struct _GtkVSeparator",
    superclasses: {<GtkSeparator>, <AtkImplementorIface>};
  struct "struct _GtkWidget",
    superclasses: {<GtkObject>, <AtkImplementorIface>};
  struct "struct _GtkWindow",
    superclasses: {<GtkBin>, <AtkImplementorIface>};
  struct "struct _GtkWindowGroup",
    superclasses: {<GObject>};
end interface;


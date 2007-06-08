#include <glib-object.h>
#include <gtk/gtkwidget.h>
#include <gdk/gdkwindow.h>
#include <gtk/gtkdialog.h>

GType g_type_from_instance (GTypeInstance* instance) {
    return G_TYPE_FROM_INSTANCE(instance);
}

GType g_value_type (GValue* value) {
    return G_VALUE_TYPE(value);
}

int sizeof_gvalue() {
    return sizeof(GValue);
}

int sizeof_gclosure() {
    return sizeof(GClosure);
}

int g_is_value (GValue* value) {
    return G_IS_VALUE(value);
}

GdkWindow* gtk_widget_get_window (GtkWidget* widget) {
    return widget->window;
}

int gtk_widget_get_state (GtkWidget* widget) {
    return GTK_WIDGET_STATE(widget);
}

GtkWidget* gtk_dialog_get_vbox (GtkDialog* dialog) {
    return GTK_DIALOG(dialog)->vbox;
}

GtkWidget* gtk_dialog_get_action_area (GtkDialog* dialog) {
    return GTK_DIALOG(dialog)->action_area;
}

struct GtkAllocation* gtk_widget_get_allocation (GtkWidget* widget) {
    return &(widget->allocation);
}

void g_value_nullify(GValue* gvalue) {
    char* foo = (char*)gvalue;
    int i;

    for(i=0; i<sizeof(GValue); i++,foo++)
      *foo = 0;
}




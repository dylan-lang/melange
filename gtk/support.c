#include <glib-object.h>
#include <gtk/gtkwidget.h>
#include <gdk/gdkwindow.h>

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

struct GtkAllocation* gtk_widget_get_allocation (GtkWidget* widget) {
    return &(widget->allocation);
}


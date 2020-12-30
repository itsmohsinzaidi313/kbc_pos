class DashboardItemModel {

  String img, name, subtitle;
  List<DashboardItemModel> _dashboardItemModel;

  DashboardItemModel({this.img, this.name, this.subtitle});

  List<DashboardItemModel> get dashboardItemModel {
    _dashboardItemModel = [
      DashboardItemModel(
          img: 'assets/sales.png',
          name: 'New Orders',
          subtitle: 'Your new sales'),
      DashboardItemModel(
          img: 'assets/order.png',
          name: 'Pending Orders',
          subtitle: 'Your pending orders'),
      DashboardItemModel(
          img: 'assets/report.png',
          name: 'Reports',
          subtitle: 'Your daily reports'),
      DashboardItemModel(
          img: 'assets/setting.png',
          name: 'Setting',
          subtitle: 'Application setting'),
      DashboardItemModel(
          img: 'assets/register.png',
          name: 'Close Register',
          subtitle: 'Close your register'),
      DashboardItemModel(
          img: 'assets/logout.png', name: 'Logout', subtitle: 'You can rest'),
      DashboardItemModel(
          img: 'assets/database-storage.png',
          name: 'Database',
          subtitle: 'Provides raw database access')
    ];
    return _dashboardItemModel;
  }
}
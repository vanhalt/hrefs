module ApplicationHelper
  def qr_svg_for(url, **options)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(
      offset: 0,
      color: "#111827",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true,
      **options
    ).html_safe
  end

  def format_visit_time(value)
    value&.in_time_zone&.strftime("%Y-%m-%d %H:%M:%S %Z") || "-"
  end
end

class DataVersionDto {
  final String version;
  final int totalCount;
  final int fileSize;
  final String updatedAt;
  final String dataUrl;

  const DataVersionDto({
    required this.version,
    this.totalCount = 0,
    this.fileSize = 0,
    this.updatedAt = '',
    this.dataUrl = 'foods_latest.json.gz',
  });

  factory DataVersionDto.fromJson(Map<String, dynamic> json) {
    return DataVersionDto(
      version: json['version'] as String? ?? '',
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      fileSize: (json['file_size'] as num?)?.toInt() ?? 0,
      updatedAt: json['updated_at'] as String? ?? '',
      dataUrl: json['data_url'] as String? ?? 'foods_latest.json.gz',
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'total_count': totalCount,
    'file_size': fileSize,
    'updated_at': updatedAt,
    'data_url': dataUrl,
  };
}

# frozen_string_literal: true

# Rails Active Record Encryption requires three secrets:
# - primary_key
# - deterministic_key
# - key_derivation_salt
#
# We read them from ENV first (best for production), then fall back to
# Rails credentials for development/test convenience.
Rails.application.config.to_prepare do
  encryption = Rails.application.config.active_record.encryption

  primary_key =
    ENV["AR_ENCRYPTION_PRIMARY_KEY"].presence ||
    Rails.application.credentials.dig(:active_record_encryption, :primary_key).presence

  deterministic_key =
    ENV["AR_ENCRYPTION_DETERMINISTIC_KEY"].presence ||
    Rails.application.credentials.dig(:active_record_encryption, :deterministic_key).presence

  key_derivation_salt =
    ENV["AR_ENCRYPTION_KEY_DERIVATION_SALT"].presence ||
    Rails.application.credentials.dig(:active_record_encryption, :key_derivation_salt).presence

  encryption.primary_key = primary_key if primary_key.present?
  encryption.deterministic_key = deterministic_key if deterministic_key.present?
  encryption.key_derivation_salt = key_derivation_salt if key_derivation_salt.present?

  Rails.logger.info(
    "[AR Encryption init] env_present=" \
      "{primary:#{ENV['AR_ENCRYPTION_PRIMARY_KEY'].present?}," \
      "deterministic:#{ENV['AR_ENCRYPTION_DETERMINISTIC_KEY'].present?}," \
      "salt:#{ENV['AR_ENCRYPTION_KEY_DERIVATION_SALT'].present?}} " \
      "credentials_present=" \
      "{primary:#{Rails.application.credentials.dig(:active_record_encryption, :primary_key).present?}," \
      "deterministic:#{Rails.application.credentials.dig(:active_record_encryption, :deterministic_key).present?}," \
      "salt:#{Rails.application.credentials.dig(:active_record_encryption, :key_derivation_salt).present?}}"
  )

  missing = []
  missing << "primary_key" if encryption.primary_key.blank?
  missing << "deterministic_key" if encryption.deterministic_key.blank?
  missing << "key_derivation_salt" if encryption.key_derivation_salt.blank?

  if missing.any?
    raise ActiveRecord::Encryption::Errors::Configuration,
          "Missing Active Record encryption credential(s): #{missing.join(', ')}. " \
          "Set ENV AR_ENCRYPTION_PRIMARY_KEY / AR_ENCRYPTION_DETERMINISTIC_KEY / " \
          "AR_ENCRYPTION_KEY_DERIVATION_SALT or add them to credentials under " \
          "active_record_encryption:."
  end
end

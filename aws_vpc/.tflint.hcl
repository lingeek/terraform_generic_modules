plugin "aws" {
    enabled = true
    version = "0.24.1"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
    // Plugin common attributes
    enabled = true
    preset = "all"
}
# Disallow terraform declarations without require_version.
rule "terraform_required_version" {
enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
   custom_formats = {
    custom_format = {
      description = "Allowed Format"
      regex       = "^[a-zA-Z]+([_-][a-zA-Z]+)*$"
    }
  }
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}


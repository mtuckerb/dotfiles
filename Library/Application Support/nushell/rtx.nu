export-env {
  let-env RTX_SHELL = "nu"
  
  let-env config = ($env.config | upsert hooks {
      pre_prompt: [{
      condition: {|| "RTX_SHELL" in $env }
      code: { || rtx_hook }
      }]
      env_change: {
          PWD: [{
          condition: {|| "RTX_SHELL" in $env }
          code: { || rtx_hook }
          }]
      }
  })
}
  
def "parse vars" [] {
  $in | lines | parse "{op},{name},{value}"
}
  
def-env rtx [command?: string, --help, ...rest: string] {
  let commands = ["shell", "deactivate"]
  
  if ($command == null) {
    ^"/Users/mtuckerb/.asdf/installs/rust/1.65.0/bin/rtx"
  } else if ($command == "activate") {
    let-env RTX_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/Users/mtuckerb/.asdf/installs/rust/1.65.0/bin/rtx" $command $rest
    | parse vars
    | update-env
  } else {
    ^"/Users/mtuckerb/.asdf/installs/rust/1.65.0/bin/rtx" /Users/mtuckerb/.asdf/installs/rust/1.65.0/bin/rtx $command $rest
  }
}
  
def-env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      let-env $var.name = $"($var.value)"
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}
  
def-env rtx_hook [] {
  ^"/Users/mtuckerb/.asdf/installs/rust/1.65.0/bin/rtx" hook-env -s nu
    | parse vars
    | update-env
}


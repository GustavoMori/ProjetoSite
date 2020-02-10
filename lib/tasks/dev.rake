namespace :dev do
  DEFAULT_PASSWORD = 123456
  
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB.."){ %x(rails db:drop:_unsafe) }
      show_spinner("Criando DB..") { %x(rails db:create) }
      show_spinner("Migrando DB..") { %x(rails db:migrate) }
      show_spinner("Cadastrando administrador padrão") { %x(rails dev:add_default_admin) }
      show_spinner("Cadastrando usuário padrão") { %x(rails dev:add_default_user) }
      #%x(rails dev:add_mining_types)
      #%x(rails dev:add_coins)
    else
      puts "Você não está em ambiente de desenovimento!"
    end
  end

  private
  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  desc "Adiciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end
end

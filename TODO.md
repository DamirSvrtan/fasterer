Issue: https://github.com/DamirSvrtan/fasterer/issues/91
1. Исследовать механизм отключения проверок через конфиг файл
2. Придумать нейминг комментов
   `# fasterer:disable rescue_vs_respond_to`, например
3. В момент парсинга файла, если встречается коммент, и коммент матчится на свой нейминг, 
   то сохраняем состояние analyzer в переменную:
   ```ruby
      inline_checks = {
        enable: [offence_name],
        disable: [offence_name]
      }
   ```
   В случае enable не выкидываем offence_name из метода offenses_grouped_by_type.
   В случае disable просто не накапливаем ошибки, которые в хеше inline_checks под ключом disable.

mob
	var
		macro_set[0]

client
	verb
		set_macro(macro_id as text, new_key as text)
			set hidden=1
			winset(src, "macro.[macro_id]", "name=\"[new_key]\"")
			if(mob) mob.macro_set["macro.[macro_id].name"] = new_key
			refresh_options()

		show_options()
			set hidden=1
			winshow(src, "options")
			refresh_options()

		close_options()
			set hidden=1
			winshow(src, "options", 0)
			refresh_macros()

		refresh_options()
			set hidden=1
			var/list/macros = params2list(winget(src, "macro.*", "name"))
			winset(src, "options_macro_pane.skill1_input", "text=\"[macros["macro.use-skill-1.name"]]\"")
			winset(src, "options_macro_pane.skill2_input", "text=\"[macros["macro.use-skill-2.name"]]\"")
			winset(src, "options_macro_pane.skill3_input", "text=\"[macros["macro.use-skill-3.name"]]\"")
			winset(src, "options_macro_pane.skill4_input", "text=\"[macros["macro.use-skill-4.name"]]\"")
			winset(src, "options_macro_pane.skill5_input", "text=\"[macros["macro.use-skill-5.name"]]\"")
			winset(src, "options_macro_pane.skill6_input", "text=\"[macros["macro.use-skill-6.name"]]\"")
			winset(src, "options_macro_pane.skill7_input", "text=\"[macros["macro.use-skill-7.name"]]\"")
			winset(src, "options_macro_pane.skill8_input", "text=\"[macros["macro.use-skill-8.name"]]\"")
			winset(src, "options_macro_pane.skill9_input", "text=\"[macros["macro.use-skill-9.name"]]\"")
			winset(src, "options_macro_pane.skill10_input", "text=\"[macros["macro.use-skill-10.name"]]\"")

			winset(src, "options_macro_pane.attack_input", "text=\"[macros["macro.attack.name"]]\"")
			winset(src, "options_macro_pane.defend_input", "text=\"[macros["macro.defend.name"]]\"")
			winset(src, "options_macro_pane.use_weapon_input", "text=\"[macros["macro.use.name"]]\"")
			winset(src, "options_macro_pane.trigger_input", "text=\"[macros["macro.trigger.name"]]\"")
			winset(src, "options_macro_pane.interact_input", "text=\"[macros["macro.interact.name"]]\"")

			winset(src, "options_macro_pane.next_target_input", "text=\"[macros["macro.target-next.name"]]\"")
			winset(src, "options_macro_pane.prev_target_input", "text=\"[macros["macro.target-prev.name"]]\"")
			winset(src, "options_macro_pane.add_next_target_input", "text=\"[macros["macro.target-plus-next.name"]]\"")
			winset(src, "options_macro_pane.add_prev_target_input", "text=\"[macros["macro.target-plus-prev.name"]]\"")
			winset(src, "options_macro_pane.untarget_input", "text=\"[macros["macro.untarget.name"]]\"")

		refresh_macros()
			set hidden=1
			if(mob)
				var/list/macros = params2list(winget(src, "macro.*", "name"))
				var/list/macro_inputs = params2list(winget(src, "options_macro_pane.*", "text"))
				var/list/macro_changes[0]

				if(macros["macro.use-skill-1.name"] != macro_inputs["options_macro_pane.skill1_input.text"])
					macro_changes["macro.use-skill-1.name"] = macro_inputs["options_macro_pane.skill1_input.text"]
				if(macros["macro.use-skill-2.name"] != macro_inputs["options_macro_pane.skill2_input.text"])
					macro_changes["macro.use-skill-2.name"] = macro_inputs["options_macro_pane.skill2_input.text"]
				if(macros["macro.use-skill-3.name"] != macro_inputs["options_macro_pane.skill3_input.text"])
					macro_changes["macro.use-skill-3.name"] = macro_inputs["options_macro_pane.skill3_input.text"]
				if(macros["macro.use-skill-4.name"] != macro_inputs["options_macro_pane.skill4_input.text"])
					macro_changes["macro.use-skill-4.name"] = macro_inputs["options_macro_pane.skill4_input.text"]
				if(macros["macro.use-skill-5.name"] != macro_inputs["options_macro_pane.skill5_input.text"])
					macro_changes["macro.use-skill-5.name"] = macro_inputs["options_macro_pane.skill5_input.text"]
				if(macros["macro.use-skill-6.name"] != macro_inputs["options_macro_pane.skill6_input.text"])
					macro_changes["macro.use-skill-6.name"] = macro_inputs["options_macro_pane.skill6_input.text"]
				if(macros["macro.use-skill-7.name"] != macro_inputs["options_macro_pane.skill7_input.text"])
					macro_changes["macro.use-skill-7.name"] = macro_inputs["options_macro_pane.skill7_input.text"]
				if(macros["macro.use-skill-8.name"] != macro_inputs["options_macro_pane.skill8_input.text"])
					macro_changes["macro.use-skill-8.name"] = macro_inputs["options_macro_pane.skill8_input.text"]
				if(macros["macro.use-skill-9.name"] != macro_inputs["options_macro_pane.skill9_input.text"])
					macro_changes["macro.use-skill-9.name"] = macro_inputs["options_macro_pane.skill9_input.text"]
				if(macros["macro.use-skill-10.name"] != macro_inputs["options_macro_pane.skill10_input.text"])
					macro_changes["macro.use-skill-10.name"] = macro_inputs["options_macro_pane.skill10_input.text"]

				if(macros["macro.attack.name"] != macro_inputs["options_macro_pane.attack_input.text"])
					macro_changes["macro.attack.name"] = macro_inputs["options_macro_pane.attack_input.text"]
				if(macros["macro.defend.name"] != macro_inputs["options_macro_pane.defend_input.text"])
					macro_changes["macro.defend.name"] = macro_inputs["options_macro_pane.defend_input.text"]
				if(macros["macro.use.name"] != macro_inputs["options_macro_pane.use_weapon_input.text"])
					macro_changes["macro.use.name"] = macro_inputs["options_macro_pane.use_weapon_input.text"]
				if(macros["macro.trigger.name"] != macro_inputs["options_macro_pane.trigger_input.text"])
					macro_changes["macro.trigger.name"] = macro_inputs["options_macro_pane.trigger_input.text"]
				if(macros["macro.interact.name"] != macro_inputs["options_macro_pane.interact_input.text"])
					macro_changes["macro.interact.name"] = macro_inputs["options_macro_pane.interact_input.text"]

				if(macros["macro.target-next.name"] != macro_inputs["options_macro_pane.next_target_input.text"])
					macro_changes["macro.target-next.name"] = macro_inputs["options_macro_pane.next_target_input.text"]
				if(macros["macro.target-prev.name"] != macro_inputs["options_macro_pane.prev_target_input.text"])
					macro_changes["macro.target-prev.name"] = macro_inputs["options_macro_pane.prev_target_input.text"]
				if(macros["macro.target-plus-next.name"] != macro_inputs["options_macro_pane.add_next_target_input.text"])
					macro_changes["macro.target-plus-next.name"] = macro_inputs["options_macro_pane.add_next_target_input.text"]
				if(macros["macro.target-plus-prev.name"] != macro_inputs["options_macro_pane.add_prev_target_input.text"])
					macro_changes["macro.target-plus-prev.name"] = macro_inputs["options_macro_pane.add_prev_target_input.text"]
				if(macros["macro.untarget.name"] != macro_inputs["options_macro_pane.untarget_input.text"])
					macro_changes["macro.untarget.name"] = macro_inputs["options_macro_pane.untarget_input.text"]

				winset(src, null, list2params(macro_changes))
				if(mob)
					for(var/macro in macro_changes)
						mob.macro_set[macro] = macro_changes[macro]
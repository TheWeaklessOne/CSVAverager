NAME		=	averager

CC			=	swiftc

FLAGS		=	-Wall -Wextra -Werror

OBJ_DIR		=	.objs/

SRC_DIR		=	Sources/

SRC_BASE	=	main.swift						\
				SwiftCSV/CSV.swift				\
				SwiftCSV/Description.swift		\
				SwiftCSV/EnumeratedView.swift	\
				SwiftCSV/NamedView.swift		\
				SwiftCSV/Parser.swift			\
				SwiftCSV/ParsingState.swift		\
				SwiftCSV/String+Lines.swift		\

SRCS		=	$(addprefix $(SRC_DIR), $(SRC_BASE))

all:
	@make -j $(NAME)

$(NAME):
	@$(CC) $(SRCS) -o $(NAME)
	@printf "\r\033[32;5;202m ✓ compile succeeded - $(NAME)\033[0m\033[K\n"

clean:
	@rm -rf $(OBJ_DIR)
	@printf "\r\033[38;5;202m✖  clean $(NAME)\033[0m\033[K\n"

fclean:		clean
	@rm -f $(NAME)
	@printf "\r\033[38;5;196m❌ fclean $(NAME)\033[0m\033[K\n"

re:		fclean all

-include $(OBJS:.o=.d)

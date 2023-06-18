PGDMP     	                    {           Majster    15.2    15.2 $    5           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            6           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            7           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            8           1262    17669    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false            �            1259    17670    users    TABLE     �  CREATE TABLE public.users (
    user_id bigint NOT NULL,
    user_name character varying(100) NOT NULL,
    user_surname character varying(100) NOT NULL,
    user_email character varying(100) NOT NULL,
    user_login character varying(100) NOT NULL,
    user_password character varying(100) NOT NULL,
    user_role character varying(100) DEFAULT USER NOT NULL,
    user_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    17677    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    214            9           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17678    alerts    TABLE       CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp with time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL,
    alert_machine_id bigint DEFAULT 0,
    alert_status character varying DEFAULT 'Brak'::character varying NOT NULL,
    alert_repairer_id bigint DEFAULT 0
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215            �            1259    17688    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false            �            1259    17692    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    217            :           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17693    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215            �            1259    17697    services    TABLE     #  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp with time zone NOT NULL,
    service_end_date timestamp with time zone,
    service_exist boolean DEFAULT true NOT NULL,
    service_status character varying(20) DEFAULT 'Nie zaczęte'::character varying,
    service_user_id bigint DEFAULT 0
);
    DROP TABLE public.services;
       public         heap    postgres    false    218            �            1259    17706    tasks    TABLE     �  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp with time zone NOT NULL,
    task_start_date timestamp with time zone,
    task_end_date timestamp with time zone,
    task_exist boolean DEFAULT true NOT NULL,
    task_start_date_by_user timestamp with time zone
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    218            �           2604    17713    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17714    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            -          0    17678    alerts 
   TABLE DATA           �   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist, alert_machine_id, alert_status, alert_repairer_id) FROM stdin;
    public          postgres    false    216   �/       .          0    17688    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   v2       0          0    17693    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   �2       1          0    17697    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220    3       2          0    17706    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   *5       +          0    17670    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   f7       ;           0    0    machines_machine_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.machines_machine_id_seq', 108, true);
          public          postgres    false    218            <           0    0    users_user_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.users_user_id_seq', 108, true);
          public          postgres    false    215            �           2606    17716    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17718    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17720    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17722    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17724    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17726    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17727    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    3216    217    220            �           2606    17732    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    3216    217    219            �           2606    17752    alerts machine_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT machine_fkey FOREIGN KEY (alert_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 =   ALTER TABLE ONLY public.alerts DROP CONSTRAINT machine_fkey;
       public          postgres    false    216    3216    217            �           2606    17737    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    3222    221    219            �           2606    17742    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    214    216    3212            �           2606    17747    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    219    214    3212            -   w  x�}T���0��P�bw�%�.}��d&M�,c�xL��|D�%�����`O@�p�9�i��ٺ�C5X�r�B���%�k�\?Q�Dѧ��.�Aus����߅�b���T�j���2�u�	f�1Di6#0}M��؟�S�������YR�"��u��c������ѼAs�q\z�a���}8�������0'7�)�y��^�M9���7���f��Q�x��Ů��s�+��a˗���)xYO�<���.l��b�n�*C�=���&�8�����B����,���1�����ǚ�/<jǅc�Hcg�ec5���O��S-H���zR w��BMh���2B�o���r�#���j1C&�����&`�UGB�h�v)ʃ?�с�®��Y��;�@�J��ğ����^�NH'4aɰ6Qd5���VH��\��xU�x@gK�������Bb4n��8�c@�)�V�Q ��=n�'m�N���^$}i��fq,+�n��/\�?`��n/����z�r^���-�g<��<tؽ�E�3'���:M��_'��"{P����.�]���l������:-�)u:Uc� \`�?�U�>���b�;Q��      .   ]   x�34��H,��K/�ϋ7q7�,�,H�I,�N�.(J,�K�,�24���L75s�%��I��$|�B2�9�1Ur:�9�p��g�I��qqq �(u      0      x������ � �      1     x���݊�0�����13��sz���!�$��bv/�n}�ɩcG���X��?�9#��5��:�}��@Q��
}�6i��{BҺ������ܟ�:mG&�B���WZ�M |=�Qh`���^y�O���Z)$��1Y���e*$��F�v^]�)�X%)��^�դ�uܒ�3kυ\ƭ!��M�"�����V/�\�K�_����6p�JQAYoZ��8��|���8��y���2�߿zٿO���&ٚl���Z��EV�o-2F̹��94s�{6��c��O�c�݇����orIP��<.��F�z8���������%W��}�B�w�� <��I.Q|Џ�iW��E�w�vҭ�0z`f��_cA��?qtъa��YR��ND%3PzZiM�u]t�y�����>*��y?ūZ�\��-a�a��)���;�5�Yb	Q��"o�^��p�븏�s�V.�w:���B�;������h$B���A:n�P���wJy��	�Ӟ(�����[ }C      2   ,  x��U˲�0]����N4zX~�n�����O:�߯d !�i$>6G:>1?w�a��YΨg._�*�*	BH?��P���1w!�ڠ�� �_y�8<���a|L��{z�"�[�*p{5�,�]p��T�*J,MP�IZex^����1���Ec率ce�q�#���b�{�g#��X6!��%��Y�"δ�=.+?/�2V����1��2|H;y����t���t�n��l'�U8J�!WT(R�P@Sr�� ���|���e���Ϲ&�����{z�/"�Y,c��6�!��NQ�pv�����i��$B�CI���KP���1I���b���J����U�-��*:�en0���س��������u'��y�7�A{5'V��Y;P�R K'���s�%4���M�G�]I7��3Z��{�Iϡ��JBwͮ�\O���5be���N>a���K�YgSt���5Na�'��Un�f!#��{=���{{���M��\r�*��\�Xv�.u@�v��>�]���W�>,��
�A�����m�+<��%خː�/�/8�N ��c      +   �   x�u�M
�@�יÔ�?p׍ �ڥ�PG秵3�ԣx�e��E�<����0[z
	M�y�$��i�-oOZpl;4P8���E���(U\N�%����u�E�PIU�л?F�
Tg� =�q�0hy����c�u��4�?}³4�?E�hÜ��g:� k��b�= ����G-�_Jh� {q��<Kӑ�%��&��1a�} ����     
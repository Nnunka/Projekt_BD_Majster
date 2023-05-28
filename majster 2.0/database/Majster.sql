PGDMP         "                {           Majster    15.2    15.2 %    1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            4           1262    16518    Majster    DATABASE     |   CREATE DATABASE "Majster" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE "Majster";
                Majster    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                pg_database_owner    false            5           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                   pg_database_owner    false    4            �            1259    17228    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false    4            �            1259    17235    users_user_id_seq    SEQUENCE     z   CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.users_user_id_seq;
       public          postgres    false    4    214            6           0    0    users_user_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;
          public          postgres    false    215            �            1259    17236    alerts    TABLE     g  CREATE TABLE public.alerts (
    alert_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    alert_title character varying(100) NOT NULL,
    alert_who_add_id bigint NOT NULL,
    alert_details character varying(10000) NOT NULL,
    alert_add_date timestamp without time zone NOT NULL,
    alert_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.alerts;
       public         heap    postgres    false    215    4            �            1259    17243    machines    TABLE     
  CREATE TABLE public.machines (
    machine_id bigint NOT NULL,
    machine_name character varying(100) NOT NULL,
    machine_type character varying(100) NOT NULL,
    machine_status character varying(100) NOT NULL,
    machine_exist boolean DEFAULT true NOT NULL
);
    DROP TABLE public.machines;
       public         heap    postgres    false    4            �            1259    17247    machines_machine_id_seq    SEQUENCE     �   CREATE SEQUENCE public.machines_machine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.machines_machine_id_seq;
       public          postgres    false    4    217            7           0    0    machines_machine_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.machines_machine_id_seq OWNED BY public.machines.machine_id;
          public          postgres    false    218            �            1259    17248    realize_tasks    TABLE     �   CREATE TABLE public.realize_tasks (
    realize_id bigint DEFAULT nextval('public.users_user_id_seq'::regclass) NOT NULL,
    realize_user_id bigint NOT NULL,
    realize_machine_id bigint NOT NULL,
    realize_task_id bigint NOT NULL
);
 !   DROP TABLE public.realize_tasks;
       public         heap    postgres    false    215    4            �            1259    17252    services    TABLE     &  CREATE TABLE public.services (
    service_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    service_title character varying(100) NOT NULL,
    service_machine_id bigint NOT NULL,
    service_details character varying(10000) NOT NULL,
    service_start_date timestamp without time zone NOT NULL,
    service_end_date timestamp without time zone,
    service_exist boolean DEFAULT true NOT NULL,
    service_status character varying(20) DEFAULT 'W trakcie'::character varying,
    service_user_id bigint DEFAULT 0
);
    DROP TABLE public.services;
       public         heap    postgres    false    218    4            �            1259    17261    tasks    TABLE     �  CREATE TABLE public.tasks (
    task_id bigint DEFAULT nextval('public.machines_machine_id_seq'::regclass) NOT NULL,
    task_title character varying(100) NOT NULL,
    task_details character varying(10000) NOT NULL,
    task_add_date timestamp without time zone NOT NULL,
    task_start_date timestamp without time zone,
    task_end_date timestamp without time zone,
    task_exist boolean DEFAULT true NOT NULL,
    task_start_date_by_user timestamp without time zone
);
    DROP TABLE public.tasks;
       public         heap    postgres    false    218    4                       2604    17268    machines machine_id    DEFAULT     z   ALTER TABLE ONLY public.machines ALTER COLUMN machine_id SET DEFAULT nextval('public.machines_machine_id_seq'::regclass);
 B   ALTER TABLE public.machines ALTER COLUMN machine_id DROP DEFAULT;
       public          postgres    false    218    217            z           2604    17269    users user_id    DEFAULT     n   ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);
 <   ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
       public          postgres    false    215    214            )          0    17236    alerts 
   TABLE DATA           u   COPY public.alerts (alert_id, alert_title, alert_who_add_id, alert_details, alert_add_date, alert_exist) FROM stdin;
    public          postgres    false    216   Q/       *          0    17243    machines 
   TABLE DATA           i   COPY public.machines (machine_id, machine_name, machine_type, machine_status, machine_exist) FROM stdin;
    public          postgres    false    217   r0       ,          0    17248    realize_tasks 
   TABLE DATA           i   COPY public.realize_tasks (realize_id, realize_user_id, realize_machine_id, realize_task_id) FROM stdin;
    public          postgres    false    219   �0       -          0    17252    services 
   TABLE DATA           �   COPY public.services (service_id, service_title, service_machine_id, service_details, service_start_date, service_end_date, service_exist, service_status, service_user_id) FROM stdin;
    public          postgres    false    220   1       .          0    17261    tasks 
   TABLE DATA           �   COPY public.tasks (task_id, task_title, task_details, task_add_date, task_start_date, task_end_date, task_exist, task_start_date_by_user) FROM stdin;
    public          postgres    false    221   �1       '          0    17228    users 
   TABLE DATA              COPY public.users (user_id, user_name, user_surname, user_email, user_login, user_password, user_role, user_exist) FROM stdin;
    public          postgres    false    214   �2       8           0    0    machines_machine_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.machines_machine_id_seq', 57, true);
          public          postgres    false    218            9           0    0    users_user_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.users_user_id_seq', 65, true);
          public          postgres    false    215            �           2606    17271    alerts alerts_pkay 
   CONSTRAINT     V   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkay PRIMARY KEY (alert_id);
 <   ALTER TABLE ONLY public.alerts DROP CONSTRAINT alerts_pkay;
       public            postgres    false    216            �           2606    17273    machines machines_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.machines
    ADD CONSTRAINT machines_pkey PRIMARY KEY (machine_id);
 @   ALTER TABLE ONLY public.machines DROP CONSTRAINT machines_pkey;
       public            postgres    false    217            �           2606    17275    realize_tasks mut_pkay 
   CONSTRAINT     \   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT mut_pkay PRIMARY KEY (realize_id);
 @   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT mut_pkay;
       public            postgres    false    219            �           2606    17277    services serwic_pkay 
   CONSTRAINT     Z   ALTER TABLE ONLY public.services
    ADD CONSTRAINT serwic_pkay PRIMARY KEY (service_id);
 >   ALTER TABLE ONLY public.services DROP CONSTRAINT serwic_pkay;
       public            postgres    false    220            �           2606    17279    tasks tasks_pkay 
   CONSTRAINT     S   ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkay PRIMARY KEY (task_id);
 :   ALTER TABLE ONLY public.tasks DROP CONSTRAINT tasks_pkay;
       public            postgres    false    221            �           2606    17281    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    214            �           2606    17282    services machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.services
    ADD CONSTRAINT machine_fkay FOREIGN KEY (service_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 ?   ALTER TABLE ONLY public.services DROP CONSTRAINT machine_fkay;
       public          postgres    false    217    220    3213            �           2606    17287    realize_tasks machine_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT machine_fkay FOREIGN KEY (realize_machine_id) REFERENCES public.machines(machine_id) NOT VALID;
 D   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT machine_fkay;
       public          postgres    false    3213    219    217            �           2606    17292    realize_tasks taask_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT taask_fkay FOREIGN KEY (realize_task_id) REFERENCES public.tasks(task_id) NOT VALID;
 B   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT taask_fkay;
       public          postgres    false    219    3219    221            �           2606    17297    alerts user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT user_fkay FOREIGN KEY (alert_who_add_id) REFERENCES public.users(user_id) NOT VALID;
 :   ALTER TABLE ONLY public.alerts DROP CONSTRAINT user_fkay;
       public          postgres    false    216    3209    214            �           2606    17302    realize_tasks user_fkay    FK CONSTRAINT     �   ALTER TABLE ONLY public.realize_tasks
    ADD CONSTRAINT user_fkay FOREIGN KEY (realize_user_id) REFERENCES public.users(user_id) NOT VALID;
 A   ALTER TABLE ONLY public.realize_tasks DROP CONSTRAINT user_fkay;
       public          postgres    false    3209    214    219            )     x�}�=r�0���)�� 	�C�M
S�Y�`b@&��R��ɽ�'���m���$8�9�EU��*�VJa$>�	���}HOmi��`M'��J�;G�;����.��E��ئ��$P\�h�r�
�¾��ڒp8օu\��8~����kn�b!���n�NkHy8�'g�po�����i�U(��V��q�0�ǝ�_��E�$��r�n�I��,/�3�`.6�x{��>�����&v����c��(��V�����'��B�>�      *   z   x�34���L75s�.H,O,�N�t��L�I�L�24��H,��K/�ϋ7q7�,�, ʀԄ+��S��Y�Y�e����l�Y���
.(J,�KJ���V�MLW�L�,�Y�ZT�YT���� �](�      ,      x������ � �      -   �   x���K��0�|�\ E��8�tӍ�(��=��U��G�EA�F��� <�9�����zt��b���c�Z�9����x=_&@EV�*��ӡN�u�1;=�������������\���<�,^}^}p.аǈ��^0�c���1q�}ˍ��=g�s�!��wɒ��QK��v�7��a�`~%��[m8�|�G.�q��R���P      .   �   x����� ���)|M)T�ϲ�	1���Ϩ�M�;A�/�_��G�e�k}�d- $7"��͂�0Og��@(������#�Z�le��<K���Ee���e$���R2���8"|��J����݌��O���h���ߗ��p����ᩆ}s�S�&��.Ⱥ��$�w�g�����/��Y(	�D�����1o����      '   '  x�mQKN�0];����]7H6H3K6�&@��5iTM��}��U�E�g���IZxE/�Bx�t��v�4F�����Tr��3*8L�z�pFU���7ws�f
sK&�D��%��%���r�N��,�8>��$��\4��97��� .�M$GP���e�M�w0h���*y�>�Vº�>�L&�m7ΖŎ�sj�Vj�`DG!lQ(�\AՈP�-V��V�6�?��ʿ�Z��ſ�n������%Jn{�w��R.�u�J����na	�R��Ň�4����Ʒ�����D     